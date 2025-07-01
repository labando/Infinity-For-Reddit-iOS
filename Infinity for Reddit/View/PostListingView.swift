//
//  PostListingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-04.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct PostListingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var navigationBarMenuManager: NavigationBarMenuManager
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    @StateObject var postListingViewModel: PostListingViewModel
    @State private var isRootView: Bool = true
    @State private var showNewPostMenu: Bool = false
    @State private var showSortTypeSheet: Bool = false
    
    private let account: Account
    private let postListingMetadata: PostListingMetadata
    private var isSubredditPostListing: Bool = false
    
    init(account: Account, postListingMetadata: PostListingMetadata) {
        self.account = account
        self.postListingMetadata = postListingMetadata
        if case .subreddit = postListingMetadata.postListingType {
            isSubredditPostListing = true
        }
        
        _postListingViewModel = StateObject(
            wrappedValue: PostListingViewModel(
                postListingMetadata: postListingMetadata,
                postListingRepository: PostListingRepository()
            )
        )
    }
    
    init(account: Account, postListingMetadata: PostListingMetadata, isRootView: Bool) {
        self.account = account
        self.isRootView = isRootView
        self.postListingMetadata = postListingMetadata
        if case .subreddit = postListingMetadata.postListingType {
            isSubredditPostListing = true
        }
        
        _postListingViewModel = StateObject(
            wrappedValue: PostListingViewModel(
                postListingMetadata: postListingMetadata,
                postListingRepository: PostListingRepository()
            )
        )
    }
    
    var body: some View {
        Group {
            if postListingViewModel.posts.isEmpty {
                if postListingViewModel.isInitialLoading || postListingViewModel.isInitialLoad {
                    ProgressIndicator()
                } else {
                    Text("No posts")
                }
            } else {
                if isRootView {
                    List {
                        ForEach(postListingViewModel.posts, id: \.id) { post in
                            PostViewCard(account: account, post: post, isSubredditPostListing: isSubredditPostListing)
                                .id(post.id)
                                .listPlainItemNoInsets()
                                .onAppear {
                                    if post.subredditOrUserIcon == nil {
                                        Task {
                                            await postListingViewModel.loadIcon(post: post, displaySubredditIcon: !isSubredditPostListing)
                                        }
                                    }
                                }
                        }
                        if postListingViewModel.hasMorePages {
                            ProgressIndicator()
                                .task {
                                    await postListingViewModel.loadPosts(isRefreshWithContinuation: false)
                                }
                                .listPlainItem()
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .themedList()
                    .refreshable {
                        await postListingViewModel.refreshPostsWithContinuation()
                    }
                } else {
                    ForEach(postListingViewModel.posts, id: \.id) { post in
                        PostViewCard(account: account, post: post, isSubredditPostListing: isSubredditPostListing)
                            .id(post.id)
                            .listPlainItemNoInsets()
                            .onAppear {
                                if post.subredditOrUserIcon == nil {
                                    Task {
                                        await postListingViewModel.loadIcon(post: post, displaySubredditIcon: !isSubredditPostListing)
                                    }
                                }
                            }
                    }
                    if postListingViewModel.hasMorePages {
                        ProgressIndicator()
                            .task {
                                await postListingViewModel.loadPosts()
                            }
                            .listPlainItem()
                    }
                }
            }
        }
        .onChange(of: colorScheme) {
            //print(colorScheme == .dark)
        }
        .task(id: postListingViewModel.loadPostsTaskId) {
            await postListingViewModel.initialLoadPosts()
        }
        .onAppear {
            navigationBarMenuManager.push([
                NavigationBarMenuItem(title: "Refresh") {
                    postListingViewModel.refreshPosts()
                },
                
                NavigationBarMenuItem(title: "Sort") {
                    showSortTypeSheet = true
                },
                
                NavigationBarMenuItem(title: "New Post") {
                    showNewPostMenu = true
                },
            ])
        }
        .onDisappear {
            navigationBarMenuManager.pop()
        }
        .sheet(isPresented: $showNewPostMenu) {
            NewPostSheet()
                .themedList()
                .presentationDetents([.medium, .large])
                .foregroundColor(Color(hex: themeViewModel.currentCustomTheme.primaryTextColor))
        }
        .sheet(isPresented: $showSortTypeSheet) {
            SortTypeSheet(postListingType: postListingMetadata.postListingType, currentSortType: postListingViewModel.sortType) { sortType in
                postListingViewModel.changeSortType(sortType: sortType)
            }
            .presentationDetents([.medium, .large])
        }
    }
}
