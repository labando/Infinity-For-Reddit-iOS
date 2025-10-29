//
//  CommentListingType.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-17.
//

import Foundation

extension CommentListingType {
    var savedSortType: SortType {
        switch self {
        case .user(let username):
            return SortTypeUserDetailsUtils.getUserComment(username: username)
        case .userSaved:
            // Shouldn't have a sort type
            return SortType(type: .new, time: nil)
        }
    }
    
    func saveSortType(sortType: SortType) {
        switch self {
        case .user(let username):
            UserDefaults.sortType?.set(sortType.type.rawValue, forKey: SortTypeUserDetailsUtils.userCommentSortTypeKey + username)
            if let time = sortType.time {
                UserDefaults.sortType?.set(time.rawValue, forKey: SortTypeUserDetailsUtils.userCommentSortTimeKey + username)
            }
        case .userSaved:
            break
        }
    }
}
