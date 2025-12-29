//
//  PostFilterUsageListingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-03.
//

import SwiftUI

struct PostFilterUsageListingView: View {
    @StateObject private var postFilterUsageViewModel: PostFilterUsageListingViewModel
    
    @State private var showPostFilterUsageSheet: Bool = false
    @State private var showSelectSubredditsSheet: Bool = false
    @State private var showSelectUsersSheet: Bool = false
    @State private var showSelectCustomFeedsSheet: Bool = false
    
    init(postFilterId: Int) {
        _postFilterUsageViewModel = StateObject(
            wrappedValue: PostFilterUsageListingViewModel(
                postFilterId: postFilterId,
                postFilterUsageRepository: PostFilterUsageListingRepository()
            )
        )
    }
    
    var body: some View {
        RootView {
            if postFilterUsageViewModel.postFilterUsages.isEmpty {
                VStack(spacing: 0) {
                    VStack(alignment: .center, spacing: 8) {
                        Spacer()
                        
                        SwiftUI.Image(systemName: "plus.circle")
                            .primaryIcon()
                        
                        Text("Click here to apply your post filter somewhere.")
                            .primaryText()
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(32)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showPostFilterUsageSheet = true
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(postFilterUsageViewModel.postFilterUsages, id: \.self) { postFilterUsage in
                        TouchRipple(action: {
                            
                        }) {
                            VStack {
                                Text(postFilterUsage.description)
                                    .primaryText()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(Rectangle())
                            .padding(16)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                postFilterUsageViewModel.deletePostFilterUsage(postFilterUsage)
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
        .addTitleToInlineNavigationBar("Post Filter Usage")
        .toolbar {
            Button("", systemImage: "plus") {
                showPostFilterUsageSheet = true
            }
        }
        .showErrorUsingSnackbar(postFilterUsageViewModel.$error)
        .wrapContentSheet(isPresented: $showPostFilterUsageSheet) {
            PostFilterUsageSheet { usageType, nameOfUsage in
                postFilterUsageViewModel.savePostFilterUsage(usageType: usageType, nameOfUsage: nameOfUsage)
            } onSelectThing: { usageType in
                switch usageType {
                case .subreddit:
                    showSelectSubredditsSheet = true
                case .user:
                    showSelectUsersSheet = true
                case .customFeed:
                    showSelectCustomFeedsSheet = true
                default:
                    // Shouldn't happen
                    break
                }
            }
        }
        .sheet(isPresented: $showSelectSubredditsSheet) {
            NavigationStack {
                SubredditAndUserMultiSelectionSheet(subscriptionSelectionMode: .subredditMultiSelection(selectedSubreddits: nil, onConfirmSelection: { things in
                    postFilterUsageViewModel.savePostFilterUsages(usageType: .subreddit, things: things)
                }))
            }
        }
        .sheet(isPresented: $showSelectUsersSheet) {
            NavigationStack {
                SubredditAndUserMultiSelectionSheet(subscriptionSelectionMode: .userMultiSelection(selectedUsers: nil, onConfirmSelection: { things in
                    postFilterUsageViewModel.savePostFilterUsages(usageType: .user, things: things)
                }))
            }
        }
        .sheet(isPresented: $showSelectCustomFeedsSheet) {
            MyCustomFeedMultiSelectionSheet { things in
                postFilterUsageViewModel.savePostFilterUsages(usageType: .customFeed, things: things)
            }
        }
    }
}
