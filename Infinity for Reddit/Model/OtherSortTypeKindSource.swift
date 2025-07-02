//
//  OtherSortTypeKindSource.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-01.
//

enum OtherSortTypeKindSource: SortTypeKindSource {
    case postDetails
    case commentListing
    case subredditListing
    case userListing
    
    var availableSortTypes: [SortType.Kind] {
        switch self {
        case .postDetails:
            return [.best, .top, .new, .controversial, .old, .random, .qa, .live]
        case .commentListing:
            return [.new, .hot, .top, .controversial]
        case .subredditListing:
            return [.relevance, .activity]
        case .userListing:
            return [.relevance, .activity]
        }
    }
}
