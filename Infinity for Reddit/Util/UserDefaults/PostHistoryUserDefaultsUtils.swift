//
//  PostHistoryUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-11.
//

import Foundation

enum PostHistoryUserDefaultsUtils {
    static let markPostsAsReadKey = "mark_posts_as_read"
    static var markPostsAsRead: Bool {
        return UserDefaults.postHistory.bool(forKey: markPostsAsReadKey)
    }
    
    static let limitReadPostsKey = "limit_read_posts"
    static var limitReadPosts: Bool {
        return UserDefaults.postHistory.bool(forKey: limitReadPostsKey)
    }
    
    static let readPostsLimitKey = "read_posts_limit"
    static var readPostsLimit: Int {
        return UserDefaults.postHistory.integer(forKey: readPostsLimitKey)
    }
    
    static let markPostsAsReadAfterVotingKey = "mark_posts_as_read_after_voting"
    static var markPostsAsReadAfterVoting: Bool {
        return UserDefaults.postHistory.bool(forKey: markPostsAsReadAfterVotingKey)
    }
    
    static let markPostsAsReadOnScrollKey = "mark_posts_as_read_on_scroll"
    static var markPostsAsReadOnScroll: Bool {
        return UserDefaults.postHistory.bool(forKey: markPostsAsReadOnScrollKey)
    }
    
    static let hideReadPostsKey = "hide_read_posts"
    static var hideReadPosts: Bool {
        return UserDefaults.postHistory.bool(forKey: hideReadPostsKey)
    }
}
