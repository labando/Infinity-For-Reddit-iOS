//
// SubredditSearchResultSheet.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-06
        
import SwiftUI

struct SubredditSearchResultSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject private var subredditListingViewModel: SubredditListingViewModel
    
    private let query: String
    private let onSubscribedSubredditSelected: (SubscribedSubredditData) -> Void
    
    init(query: String, onSubscribedSubredditSelected: @escaping (SubscribedSubredditData) -> Void) {
        self.query = query
        self.onSubscribedSubredditSelected = onSubscribedSubredditSelected
        _subredditListingViewModel = StateObject(
            wrappedValue: SubredditListingViewModel(
                query: query,
                subredditListingRepository: SubredditListingRepository()
            )
        )
    }
    
    var body: some View {
        SubredditListingView(account: accountViewModel.account, subredditListingViewModel: subredditListingViewModel) { subreddit in
            onSubscribedSubredditSelected(SubscribedSubredditData.fromSubreddit(subreddit, username: accountViewModel.account.username))
            dismiss()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Subreddits")
        .id(accountViewModel.account.username)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .navigationBarPrimaryText()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationBarMenu()
            }
        }
    }
}

