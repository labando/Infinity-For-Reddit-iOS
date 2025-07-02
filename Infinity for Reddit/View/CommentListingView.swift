//
//  CommentListingView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-15.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct CommentListingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationBarMenuManager: NavigationBarMenuManager
    
    @StateObject var commentListingViewModel: CommentListingViewModel
    @State private var showSortTypeSheet: Bool = false
    @State private var navigationBarMenuKey: UUID?
    
    init(commentListingMetadata: CommentListingMetadata) {
        _commentListingViewModel = StateObject(
            wrappedValue: CommentListingViewModel(
                commentListingMetadata: commentListingMetadata,
                commentListingRepository: CommentListingRepository()
            )
        )
    }
    
    var body: some View {
        Group {
            if commentListingViewModel.comments.isEmpty {
                if commentListingViewModel.isInitialLoading || commentListingViewModel.isInitialLoad {
                    ProgressIndicator()
                } else {
                    Text("No Comments")
                }
            } else {
                List {
                    ForEach(commentListingViewModel.comments, id: \.id) { comment in
                        CommentViewCard(account: accountViewModel.account, comment: comment, isInPostDetails: false)
                            .listPlainItemNoInsets()
                            .id(comment.id)
                    }
                    if commentListingViewModel.hasMorePages {
                        ProgressIndicator()
                            .task {
                                await commentListingViewModel.loadComments()
                            }
                            .listPlainItem()
                    }
                }.scrollBounceBehavior(.basedOnSize)
            }
        }
        .onChange(of: colorScheme) {
            //print(colorScheme == .dark)
        }
        .task(id: commentListingViewModel.loadCommentsTaskId) {
            await commentListingViewModel.initialLoadComments()
        }
        .refreshable {
            await commentListingViewModel.refreshCommentsWithContinuation()
        }
        .listStyle(.plain)
        .onAppear {
            if let key = navigationBarMenuKey {
                navigationBarMenuManager.pop(key: key)
            }
            navigationBarMenuKey = navigationBarMenuManager.push([
                NavigationBarMenuItem(title: "Refresh") {
                    commentListingViewModel.refreshComments()
                },
                
                NavigationBarMenuItem(title: "Sort") {
                    showSortTypeSheet = true
                }
            ])
        }
        .onDisappear {
            guard let navigationBarMenuKey else { return }
            navigationBarMenuManager.pop(key: navigationBarMenuKey)
        }
        .sheet(isPresented: $showSortTypeSheet) {
            SortTypeSheet(sortTypeKindSource: OtherSortTypeKindSource.commentListing, currentSortType: commentListingViewModel.sortType) { sortType in
                commentListingViewModel.changeSortType(sortType: sortType)
            }
            .presentationDetents([.medium, .large])
        }
    }
}

