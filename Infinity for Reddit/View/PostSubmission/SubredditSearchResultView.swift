//
// SubredditSearchResultView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-06
        
import SwiftUI

struct SubredditSearchResultView: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @Environment(\.dismiss) var dismiss
    
    private let query: String
    private let onSubscribedSubredditSelected: (SubscribedSubredditData) -> Void
    
    init(query: String, onSubscribedSubredditSelected: @escaping (SubscribedSubredditData) -> Void) {
        self.query = query
        self.onSubscribedSubredditSelected = onSubscribedSubredditSelected
    }
    
    var body: some View {
        SubredditListingView(account: accountViewModel.account, query: query) { subreddit in
            onSubscribedSubredditSelected(SubscribedSubredditData.fromSubreddit(subreddit, username: accountViewModel.account.username))
            dismiss()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Subreddits")
        .id(accountViewModel.account.username)
        .toolbar {
            NavigationBarMenu()
        }
    }
}

