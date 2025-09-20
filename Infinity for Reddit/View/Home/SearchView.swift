//
//  SearchView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-18.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject private var searchViewModel: SearchViewModel
    @FocusState var focusedField: FieldType?
    
    private let onSearchCustomAction: ((String) -> Void)?
    
    init(onSearchCustomAction: ((String) -> Void)? = nil) {
        self.onSearchCustomAction = onSearchCustomAction
        _searchViewModel = StateObject(wrappedValue: SearchViewModel())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Search bar
            HStack(spacing: 8) {
                SwiftUI.Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                CustomTextField("Search",
                                text: $searchViewModel.query,
                                singleLine: true,
                                showBorder: false,
                                fieldType: .search,
                                focusedField: $focusedField)
                .submitLabel(.search)
                .onSubmit {
                    if !accountViewModel.account.isAnonymous() {
                        searchViewModel.saveSearchQuery()
                    }
                    if let onSearch = onSearchCustomAction {
                        onSearch(searchViewModel.query)
                    } else {
                        navigationManager.path.append(AppNavigation.searchResults(query: searchViewModel.query, searchInSubredditOrUserName: "", searchInMultiReddit: "", searchInThingType: SearchInThingType.all))
                    }
                }
            }
            .padding(.horizontal, 12)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(16)
            
            TouchRipple(action: {
                navigationManager.path.append(ThingSelectionNavigation.selectThing)
            }) {
                HStack(spacing: 0) {
                    Text("Search in")
                        .colorAccentText()
                    
//                    RowText(postSubmissionContextViewModel.selectedSubreddit?.name ?? text)
//                        .primaryText()
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .contentShape(Rectangle())
            }
            
            // Recent Searches Header
            if !searchViewModel.recentSearchQueries.isEmpty {
                HStack {
                    Text("Recent Searches")
                        .font(.headline)
                    Spacer()
                    Button("Clear All") {
                        searchViewModel.clearAllRecentSearchQueries()
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                
                .padding(.horizontal, 16)
            }
            
            // Recent search items
            List {
                ForEach(searchViewModel.recentSearchQueries, id: \.time) { search in
                    TouchRipple(action: {
                        if let onSearch = onSearchCustomAction {
                            onSearch(search.searchQuery)
                        } else {
                            navigationManager.path.append(AppNavigation.searchResults(query: search.searchQuery, searchInSubredditOrUserName: search.searchInSubredditOrUserName, searchInMultiReddit: search.multiRedditPath, searchInThingType: search.searchInThingType))
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(search.searchQuery)
                                .primaryText()
                            
                            switch search.searchInThingType {
                            case .all:
                                Text("All subreddits")
                                    .secondaryText()
                            case .subreddit:
                                Text("r/\(search.searchInSubredditOrUserName ?? "")")
                                    .subreddit()
                            case .user:
                                Text("u/\(search.searchInSubredditOrUserName ?? "")")
                                    .username()
                            case .multireddit:
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
                        .swipeActions(edge: .trailing) {
                            Button {
                                searchViewModel.deleteSearchQuery(recentSearchQuery: search)
                            } label: {
                                Label("Read", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    .listPlainItemNoInsets()
                }
            }
            .themedList()
        }
        .rootViewBackground()
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Search")
        .navigationDestination(for: ThingSelectionNavigation.self) { destination in
            switch destination {
            case .selectThing:
                SelectSearchInThingView { searchInThing in
                    searchViewModel.searchInThing = searchInThing
                }
            }
        }
    }
    
    enum FieldType: Hashable {
        case search
    }
}
