//
//  HomeTabPostFeedType.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2026-04-05.
//

enum HomeTabPostFeedType: Int {
    case home = 1
    case subreddit = 2
    case user = 3
    case customFeed = 4
    
    var description: String {
        switch self {
        case .home:
            return "Home"
        case .subreddit:
            return "Subreddit"
        case .user:
            return "User"
        case .customFeed:
            return "Custom Feed"
        }
    }
    
    var textFieldPlaceholder: String {
        switch self {
        case .subreddit:
            return "Subreddit Name (Without r/ prefix)"
        case .user:
            return "Username (Without u/ prefix)"
        case .customFeed:
            return "MultiReddit Path (/user/yourusername/m/yourmultiredditname) (only lowercase characters)"
        default:
            // Really shouldn't happen
            return ""
        }
    }
}
