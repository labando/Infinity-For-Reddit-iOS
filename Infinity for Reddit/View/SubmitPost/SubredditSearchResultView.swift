//
// SubredditSearchResultView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-06
        
import SwiftUI

struct SubredditSearchResultView: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    @StateObject private var searchResultsViewModel: SearchResultsViewModel
    @State private var selectedOption = 0
    
    init(query: String, searchInSubredditOrUserName: String?, searchInMultiReddit: String?, searchInThingType: Int) {
        _searchResultsViewModel = StateObject(wrappedValue: SearchResultsViewModel(query: query, searchInSubredditOrUserName: searchInSubredditOrUserName, searchInMultiReddit: searchInMultiReddit, searchInThingType: searchInThingType))
    }
    
    var body: some View {
        VStack {
            SegmentedPicker(selectedValue: $selectedOption, values: ["Posts", "Subreddits", "Users"])
                .padding(4)
            
            TabView(selection: $selectedOption) {
                PostListingView(account: accountViewModel.account, postListingMetadata: PostListingMetadata(
                    postListingType: PostListingType.search(
                        query: searchResultsViewModel.query,
                        searchInSubredditOrUserName: searchResultsViewModel.searchInSubredditOrUserName,
                        searchInMultiReddit: searchResultsViewModel.searchInMultiReddit,
                        searchInThingType: searchResultsViewModel.searchInThingType
                    ),
                    headers: APIUtils.getOAuthHeader(accessToken: accountViewModel.account.accessToken ?? ""),
                    queries: ["q": searchResultsViewModel.query, "type": "link"],
                    params: nil
                ))
                .tag(0)
                
                SubredditListingView(account: accountViewModel.account, query: searchResultsViewModel.query)
                    .tag(1)
                
                UserListingView(account: accountViewModel.account, query: searchResultsViewModel.query)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar(searchResultsViewModel.query)
        .id(accountViewModel.account.username)
        .toolbar {
            NavigationBarMenu()
        }
    }
}

