//
//  HistoryPostListingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-03.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct HistoryPostListingView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var navigationBarMenuManager: NavigationBarMenuManager
    
    @StateObject var historyPostListingViewModel: HistoryPostListingViewModel
    @StateObject var postListingVideoManager: PostListingVideoManager = .init()
    @State private var navigationBarMenuKey: UUID?
    @State private var showLayoutTypeSheet: Bool = false
    @State private var showPostOptionsSheet: Bool = false
    @State private var showPostShareSheet: Bool = false
    @State private var showPostModerationSheet: Bool = false
    @State private var postForPostOptionsSheet: Post?

    private let historyPostListingMetadata: HistoryPostListingMetadata
    private let handleToolbarMenu: Bool
    private let showFilterPostsOption: Bool
    
    init(historyPostListingMetadata: HistoryPostListingMetadata,
         externalPostFilter: PostFilter? = nil,
         handleToolbarMenu: Bool = true,
         showFilterPostsOption: Bool = true
    ) {
        self.historyPostListingMetadata = historyPostListingMetadata
        self.handleToolbarMenu = handleToolbarMenu
        self.showFilterPostsOption = showFilterPostsOption
        
        _historyPostListingViewModel = StateObject(
            wrappedValue: HistoryPostListingViewModel(
                historyPostListingMetadata: historyPostListingMetadata,
                externalPostFilter: externalPostFilter,
                historyPostListingRepository: HistoryPostListingRepository(),
                historyPostsRepository: HistoryPostsRepository(),
                thingModerationRepository: ThingModerationRepository(),
                postFeedID: "read_posts"
            )
        )
    }
    
    var body: some View {
        RootView {
            if historyPostListingViewModel.posts.isEmpty {
                ZStack {
                    if historyPostListingViewModel.isInitialLoading || historyPostListingViewModel.isInitialLoad {
                        ProgressIndicator()
                    } else {
                        Text("No posts")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(historyPostListingViewModel.posts, id: \.id) { post in
                        PostView(
                            post: post,
                            postLayout: historyPostListingViewModel.postLayout,
                            isSubredditPostListing: false,
                            onPostTypeTap: {
                                onPostTypeClicked(post: post)
                            },
                            onSensitiveTap: {
                                onSensitiveClicked(post: post)
                            },
                            onLongPressPost: {
                                postForPostOptionsSheet = post
                                showPostOptionsSheet = true
                            },
                            onShare: {
                                postForPostOptionsSheet = post
                                showPostShareSheet = true
                            }
                        )
                        .id(ObjectIdentifier(post))
                        .listPlainItemNoInsets()
                        .onAppear {
                            if post.subredditOrUserIcon == nil {
                                Task {
                                    await historyPostListingViewModel.loadIcon(post: post)
                                }
                            }
                        }
                    }
                    if historyPostListingViewModel.hasMorePages {
                        ProgressIndicator()
                            .task {
                                await historyPostListingViewModel.loadPosts()
                            }
                            .listPlainItem()
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .themedList()
                .refreshable {
                    await historyPostListingViewModel.refreshPostsWithContinuation()
                }
            }
        }
        .applyIf(handleToolbarMenu) {
            $0.toolbar {
                NavigationBarMenu()
            }
        }
        .task(id: historyPostListingViewModel.loadPostsTaskId) {
            await historyPostListingViewModel.initialLoadPosts()
        }
        .onAppear {
            if let key = navigationBarMenuKey {
                navigationBarMenuManager.pop(key: key)
            }
            var options = [
                NavigationBarMenuItem(title: "Refresh") {
                    historyPostListingViewModel.refreshPosts()
                },
                
                NavigationBarMenuItem(title: "Change Post Layout") {
                    showLayoutTypeSheet = true
                }
            ]
            
            if showFilterPostsOption {
                options.append(NavigationBarMenuItem(title: "Filter Posts") {
                    navigationManager.append(
                        AppNavigation.filterHistoryPosts(
                            historyPostListingMetadata: historyPostListingMetadata
                        )
                    )
                })
            }
            
            navigationBarMenuKey = navigationBarMenuManager.push(options)
        }
        .onDisappear {
            guard let navigationBarMenuKey else { return }
            navigationBarMenuManager.pop(key: navigationBarMenuKey)
        }
        .wrapContentSheet(isPresented: $showLayoutTypeSheet) {
            PostLayoutSheet(
                currentPostLayout: historyPostListingViewModel.postLayout,
                onSelectPostLayout: { newLayout in
                    historyPostListingViewModel.changePostLayout(newLayout)
                }
            )
        }
        .wrapContentSheet(isPresented: $showPostOptionsSheet) {
            if let postForPostOptionsSheet {
                PostOptionsSheet(
                    post: postForPostOptionsSheet,
                    onComment: {
                        navigationManager.append(AppNavigation.submitComment(commentParent: .post(parentPost: postForPostOptionsSheet)))
                    },
                    onShare: {
                        showPostShareSheet = true
                    },
                    onAddToPostFilter: {
                        navigationManager.append(SettingsViewNavigation.postFilter(postToBeAdded: postForPostOptionsSheet))
                    },
                    onToggleHidePost: {
                        historyPostListingViewModel.toggleHidePost(postForPostOptionsSheet)
                    },
                    onCrosspost: {
                        navigationManager.append(AppNavigation.crosspost(postToBeCrossposted: postForPostOptionsSheet))
                    },
                    onDownloadMedia: {
                        historyPostListingViewModel.downloadMedia(postForPostOptionsSheet)
                    },
                    onDownloadAllGalleryMedia: {
                        historyPostListingViewModel.downloadAllGalleryMedia(post: postForPostOptionsSheet)
                    },
                    onReport: {
                        if AccountViewModel.shared.account.isAnonymous() {
                            navigationManager.openLink("https://www.reddit.com/report")
                        } else {
                            navigationManager.append(AppNavigation.report(subredditName: postForPostOptionsSheet.subreddit, thingFullname: postForPostOptionsSheet.name))
                        }
                    },
                    onModeration: {
                        showPostModerationSheet = true
                    }
                )
            } else {
                EmptyView()
            }
        }
        .wrapContentSheet(isPresented: $showPostModerationSheet) {
            if let postForPostOptionsSheet {
                PostModerationSheet(
                    post: postForPostOptionsSheet,
                    onApprove: {
                        historyPostListingViewModel.approvePost(postForPostOptionsSheet)
                    },
                    onRemove: {
                        historyPostListingViewModel.removePost(postForPostOptionsSheet, isSpam: false)
                    },
                    onMarkAsSpam: {
                        historyPostListingViewModel.removePost(postForPostOptionsSheet, isSpam: true)
                    },
                    onToggleStickyPost: {
                        historyPostListingViewModel.toggleSticky(postForPostOptionsSheet)
                    },
                    onToggleLock: {
                        historyPostListingViewModel.toggleLockPost(postForPostOptionsSheet)
                    },
                    onToggleSensitive: {
                        historyPostListingViewModel.toggleSensitive(postForPostOptionsSheet)
                    },
                    onToggleSpoiler: {
                        historyPostListingViewModel.toggleSpoiler(postForPostOptionsSheet)
                    },
                    onToggleDistinguishAsModerator: {
                        historyPostListingViewModel.toggleDistinguishAsMod(postForPostOptionsSheet)
                    }
                )
            } else {
                EmptyView()
            }
        }
        .wrapContentSheet(isPresented: $showPostShareSheet) {
            if let postForPostOptionsSheet {
                PostShareSheet(post: postForPostOptionsSheet)
            } else {
                EmptyView()
            }
        }
        .environment(\.postListingVideoManager, postListingVideoManager)
    }
    
    private func onPostTypeClicked(post: Post) {
        if showFilterPostsOption {
            navigationManager.append(
                AppNavigation.filteredHistoryPosts(
                    historyPostListingMetadata: historyPostListingMetadata,
                    postFilter: PostFilter.constructPostFilter(postType: post.postType)
                )
            )
        }
    }
    
    private func onSensitiveClicked(post: Post) {
        if showFilterPostsOption {
            var postFilter = PostFilter()
            postFilter.onlySensitive = true
            navigationManager.append(
                AppNavigation.filteredHistoryPosts(
                    historyPostListingMetadata: historyPostListingMetadata,
                    postFilter: postFilter
                )
            )
        }
    }
}
