//
//  InterfaceCommentUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-10.
//

import Foundation

enum InterfaceCommentUserDefaultsUtils {
    static let showTopLevelCommentsFirstKey = "show_top_level_comments_first"
    static var showTopLevelCommentsFirst: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: showTopLevelCommentsFirstKey)
    }
    
    static let showCommentDividerKey = "show_comment_divider"
    static var showCommentDivider: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: showCommentDividerKey)
    }
    
    static let showOnlyOneCommentLevelIndicatorKey = "show_only_one_comment_level_indicator"
    static var showOnlyOneCommentLevelIndicator: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: showOnlyOneCommentLevelIndicatorKey)
    }
    
    static let hideToolbarKey = "hide_toolbar"
    static var hideToolbar: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: hideToolbarKey)
    }
    
    static let fullyCollapseCommentKey = "fully_collapse_comment"
    static var fullyCollapseComment: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: fullyCollapseCommentKey)
    }
    
    static let showAuthorAvatarKey = "show_author_avatar"
    static var showAuthorAvatar: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: showAuthorAvatarKey)
    }
    
    static let alwaysShowNChildCommentsKey = "always_show_n_child_comments"
    static var alwaysShowNChildComments: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: alwaysShowNChildCommentsKey)
    }
    
    static let hideNVotesKey = "hide_n_votes"
    static var hideNVotes: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: hideNVotesKey)
    }
    
    static let showFewerToolbarOptionsThresholdKey = "show_fewer_toolbar_options_threshold"
    static var showFewerToolbarOptionsThreshold: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: showFewerToolbarOptionsThresholdKey)
    }
    
    static let embeddedMediaTypeKey = "embedded_media_type"
    static var embeddedMediaType: Bool {
        return UserDefaults.interfaceCommentFilter.bool(forKey: embeddedMediaTypeKey)
    }
}
