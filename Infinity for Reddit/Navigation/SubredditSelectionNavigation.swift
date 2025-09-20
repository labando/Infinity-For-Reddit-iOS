//
//  SubredditSelectionNavigation.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

enum SelectSubredditNavigation: Hashable {
    case selectSubreddit
}

enum SearchSubredditNavigation: Hashable {
    case searchSubreddit
}

enum SubredditSearchResultNavigation: Hashable {
    case subredditSearchResult(query: String)
}
