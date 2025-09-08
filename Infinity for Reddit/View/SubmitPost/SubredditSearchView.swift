//
// SubredditSearchView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-27
        
import SwiftUI

struct SubredditSearchView: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject private var subredditSearchViewModel: SubredditSearchViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    init(username: String) {
        _subredditSearchViewModel = StateObject(wrappedValue: SubredditSearchViewModel(username: username))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Search bar
                HStack(spacing: 8) {
                    SwiftUI.Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $subredditSearchViewModel.query)
                        .focused($isTextFieldFocused)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .submitLabel(.search)
                        .onSubmit {
                            if !accountViewModel.account.isAnonymous() {
                                subredditSearchViewModel.saveSearchQuery()
                            }
                            navigationManager.path.append(AppNavigation.searchSubreddits(query: subredditSearchViewModel.query, searchInSubredditOrUserName: "", searchInMultiReddit: "", searchInThingType: SearchInThingType.all.rawValue))
                        }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.top, 12)
                .padding(.horizontal)
                
                // Recent Searches Header
                if !subredditSearchViewModel.recentSearchQueries.isEmpty {
                    HStack {
                        Text("Recent Searches")
                            .font(.headline)
                        Spacer()
                        Button("Clear All") {
                            subredditSearchViewModel.clearAllRecentSearchQueries()
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                }
                
                // Recent search items
                VStack(spacing: 12) {
                    ForEach(subredditSearchViewModel.recentSearchQueries, id: \.time) { search in
                        TouchRipple(action: {
                            navigationManager.path.append(AppNavigation.searchSubreddits(query: search.searchQuery, searchInSubredditOrUserName: search.searchInSubredditOrUserName, searchInMultiReddit: search.multiRedditPath, searchInThingType: search.searchInThingType))
                        }) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(search.searchQuery)
                                    .primaryText()
                                
                                switch search.searchInThingType {
                                case SearchInThingType.all.rawValue:
                                    Text("All subreddits")
                                        .secondaryText()
                                case SearchInThingType.subreddit.rawValue:
                                    Text("r/\(search.searchInSubredditOrUserName ?? "")")
                                        .subreddit()
                                case SearchInThingType.user.rawValue:
                                    Text("u/\(search.searchInSubredditOrUserName ?? "")")
                                        .username()
                                case SearchInThingType.multireddit.rawValue:
                                    Text(search.multiRedditDisplayName ?? "")
                                        .secondaryText()
                                default:
                                    Text("All subreddits")
                                        .secondaryText()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .contentShape(Rectangle())
                        }
                    }
                }
                Spacer()
            }
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Search")
        .id(accountViewModel.account.username)
        .toolbar {
            NavigationBarMenu()
        }
    }
}

