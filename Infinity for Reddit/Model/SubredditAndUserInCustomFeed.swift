//
//  SubredditAndUserInCustomFeed.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

enum SubredditAndUserInCustomFeed {
    case subscribedSubreddit(SubscribedSubredditData)
    case subreddit(SubredditData)
    case subscribedUser(SubscribedUserData)
    case user(UserData)
    
    var id: String {
        switch self {
        case .subscribedSubreddit(let subscribedSubredditData):
            return subscribedSubredditData.name
        case .subreddit(let subredditData):
            return subredditData.name
        case .subscribedUser(let subscribedUserData):
            return subscribedUserData.name
        case .user(let userData):
            return userData.name
        }
    }
    
    var name: String {
        switch self {
        case .subscribedSubreddit(let subscribedSubredditData):
            return subscribedSubredditData.name
        case .subreddit(let subredditData):
            return subredditData.name
        case .subscribedUser(let subscribedUserData):
            return subscribedUserData.name
        case .user(let userData):
            return userData.name
        }
    }
    
    var iconUrlString: String? {
        switch self {
        case .subscribedSubreddit(let subscribedSubredditData):
            return subscribedSubredditData.iconUrl
        case .subreddit(let subredditData):
            return subredditData.iconUrl
        case .subscribedUser(let subscribedUserData):
            return subscribedUserData.iconUrl
        case .user(let userData):
            return userData.iconUrl
        }
    }
}
