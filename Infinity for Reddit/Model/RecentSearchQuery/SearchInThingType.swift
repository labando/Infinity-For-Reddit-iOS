//
//  SearchInThingType.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-18.
//

public enum SearchInThingType: Int, Codable, CaseIterable, Hashable {
    case all = 0
    case subreddit = 1
    case user = 2
    case customFeed = 3
}

enum SearchInThing {
    case subreddit(SubscribedSubredditData)
    case user(SubscribedUserData)
    case customFeed(MyCustomFeed)
    
    var displayName: String {
        switch self {
        case .subreddit(let subscribedSubredditData):
            return "r/\(subscribedSubredditData.name)"
        case .user(let subscribedUserData):
            return "u/\(subscribedUserData.name)"
        case .customFeed(let myCustomFeed):
            return myCustomFeed.name
        }
    }
    
    var searchInSubredditOrUserName: String {
        switch self {
        case .subreddit(let subscribedSubredditData):
            return subscribedSubredditData.name
        case .user(let subscribedUserData):
            return subscribedUserData.name
        case .customFeed:
            return ""
        }
    }
    
    var searchInCustomFeed: String {
        switch self {
        case .customFeed(let myCustomFeed):
            return myCustomFeed.path
        default:
            return ""
        }
    }
    
    var searchInThingType: SearchInThingType {
        switch self {
        case .subreddit:
            return SearchInThingType.subreddit
        case .user:
            return SearchInThingType.user
        case .customFeed:
            return SearchInThingType.customFeed
        }
    }
}
