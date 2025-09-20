//
// SubredditSearchView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-27
        
import SwiftUI

struct SearchSubredditsView: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    let onSubscribedSubredditSelected: (SubscribedSubredditData) -> Void
    
    var body: some View {
        SearchView { query in
            navigationManager.path.removeLast()
            navigationManager.path.append(SubredditSearchResultNavigation.subredditSearchResult(query: query))
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Search Subreddits")
        .id(accountViewModel.account.username)
        .navigationDestination(for: SubredditSearchResultNavigation.self) { destination in
            switch destination {
                case .subredditSearchResult(let query):
                SubredditSearchResultView(query: query) { subscribedSubreddit in
                    onSubscribedSubredditSelected(subscribedSubreddit)
                }
            }
        }
    }
}
