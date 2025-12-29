//
//  CommentFilterUsageListingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

import SwiftUI

struct CommentFilterUsageListingView: View {
    @StateObject private var commentFilterUsageListingViewModel: CommentFilterUsageListingViewModel
    
    @State private var showCommentFilterUsageSheet: Bool = false
    @State private var showSelectSubredditsSheet: Bool = false
    
    init(commentFilterId: Int) {
        _commentFilterUsageListingViewModel = StateObject(
            wrappedValue: CommentFilterUsageListingViewModel(
                commentFilterId: commentFilterId,
                commentFilterUsageListingRepository: CommentFilterUsageListingRepository()
            )
        )
    }
    
    var body: some View {
        RootView {
            if commentFilterUsageListingViewModel.commentFilterUsages.isEmpty {
                VStack(spacing: 0) {
                    VStack(alignment: .center, spacing: 8) {
                        Spacer()
                        
                        SwiftUI.Image(systemName: "plus.circle")
                            .primaryIcon()
                        
                        Text("Click here to apply your comment filter somewhere. Leave it empty to apply everywhere.")
                            .primaryText()
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(32)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showCommentFilterUsageSheet = true
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(commentFilterUsageListingViewModel.commentFilterUsages, id: \.self) { commentFilterUsage in
                        TouchRipple(action: {
                            
                        }) {
                            VStack {
                                Text(commentFilterUsage.description)
                                    .primaryText()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(Rectangle())
                            .padding(16)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                commentFilterUsageListingViewModel.deleteCommentFilterUsage(commentFilterUsage)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .listPlainItemNoInsets()
                    }
                }
                .themedList()
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Comment Filter Usage")
        .toolbar {
            Button("", systemImage: "plus") {
                showCommentFilterUsageSheet = true
            }
        }
        .showErrorUsingSnackbar(commentFilterUsageListingViewModel.$error)
        .wrapContentSheet(isPresented: $showCommentFilterUsageSheet) {
            CommentFilterUsageSheet { usageType, nameOfUsage in
                commentFilterUsageListingViewModel.saveCommentFilterUsage(usageType: usageType, nameOfUsage: nameOfUsage)
            } onSelectThing: { usageType in
                switch usageType {
                case .subreddit:
                    showSelectSubredditsSheet = true
                }
            }
        }
        .sheet(isPresented: $showSelectSubredditsSheet) {
            NavigationStack {
                SubredditAndUserMultiSelectionSheet(subscriptionSelectionMode: .subredditMultiSelection(selectedSubreddits: nil, onConfirmSelection: { things in
                    commentFilterUsageListingViewModel.saveCommentFilterUsages(usageType: .subreddit, things: things)
                }))
            }
        }
    }
}
