//
//  InterfacePostDetailsUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-10.
//

import Foundation

class InterfacePostDetailsUserDefaultsUtils {
    static let showPostAndCommentsInTwoColumnsInLandscapeKey = "show_post_and_comments_in_two_columns_in_landscape"
    static var showPostAndCommentsInTwoColumnsInLandscape: Bool {
        return UserDefaults.interfacePostDetails.bool(forKey: showPostAndCommentsInTwoColumnsInLandscapeKey, true)
    }
    
    static let hidePostTypeKey = "hide_post_type"
    static var hidePostType: Bool {
        return UserDefaults.interfacePostDetails.bool(forKey: hidePostTypeKey)
    }
    
    static let hidePostFlairKey = "hide_post_flair"
    static var hidePostFlair: Bool {
        return UserDefaults.interfacePostDetails.bool(forKey: hidePostFlairKey)
    }
    
    static let hideUpvoteRatioKey = "hide_upvote_ratio"
    static var hideUpvoteRatio: Bool {
        return UserDefaults.interfacePostDetails.bool(forKey: hideUpvoteRatioKey)
    }
    
    static let hideSubredditAndUserPrefixKey = "hide_subreddit_and_user_prefix"
    static var hideSubredditAndUserPrefix: Bool {
        return UserDefaults.interfacePostDetails.bool(forKey: hideSubredditAndUserPrefixKey)
    }
    
    static let hideNVotesKey = "hide_n_votes"
    static var hideNVotes: Bool {
        return UserDefaults.interfacePostDetails.bool(forKey: hideNVotesKey)
    }
    
    static let hideNCommentsKey = "hide_n_comments"
    static var hideNComments: Bool {
        return UserDefaults.interfacePostDetails.bool(forKey: hideNCommentsKey)
    }
    
    static let markdownEmbeddedMediaTypeKey = "embedded_media_type"
    static var markdownEmbeddedMediaType: Int {
        return UserDefaults.interfacePostDetails.integer(forKey: markdownEmbeddedMediaTypeKey, 15)
    }
    static let markdownEmbeddedMediaTypes = [15, 7, 6, 5, 3, 2, 1, 0]
    static let markdownEmbeddedMediaTypesText = ["All", "Image and Gif", "Image and Emote", "Gif and Emote", "Image", "Gif", "Emote", "None"]
}


enum MarkdownEmbeddedMediaType: Int {
    case all = 15
    case imageAndGif = 7
    case imageAndEmote = 6
    case gifAndEmote = 5
    case image = 3
    case gif = 2
    case emote = 1
    case none = 0
    
    var allowImage: Bool {
        switch self {
        case .all:
            return true
        case .imageAndGif:
            return true
        case .imageAndEmote:
            return true
        case .image:
            return true
        default:
            return false
        }
    }
    
    var allowGif: Bool {
        switch self {
        case .all:
            return true
        case .imageAndGif:
            return true
        case .gifAndEmote:
            return true
        case .gif:
            return true
        default:
            return false
        }
    }
    
    var allowEmote: Bool {
        switch self {
        case .all:
            return true
        case .imageAndEmote:
            return true
        case .gifAndEmote:
            return true
        case .emote:
            return true
        default:
            return false
        }
    }
}
