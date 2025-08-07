//
// CommentFilter.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import GRDB

public struct CommentFilter: Codable, FetchableRecord, PersistableRecord, Hashable {
    public static let databaseTableName = "comment_filter"
    
    enum DisplayMode: Int, Codable {
        case removeComment = 0
        case collapseComment = 10
    }

    var id: Int?
    var name: String = "New Filter"

    var displayMode: DisplayMode = .removeComment

    var maxVote: Int = -1
    var minVote: Int = -1
    var excludeStrings: String?
    var excludeUsers: String?
    
    var identityForView: String {
        "\(String(id ?? -1))-\(name)"
    }

    init(
        id: Int? = nil,
        name: String = "New Filter",
        displayMode: DisplayMode = .removeComment,
        maxVote: Int = -1,
        minVote: Int = -1,
        excludeStrings: String? = nil,
        excludeUsers: String? = nil
    ) {
        self.id = id
        self.name = name
        self.displayMode = displayMode
        self.maxVote = maxVote
        self.minVote = minVote
        self.excludeStrings = excludeStrings
        self.excludeUsers = excludeUsers
    }

    private enum CodingKeys: String, CodingKey, ColumnExpression {
        case id, name, displayMode = "display_mode", maxVote = "max_vote",
             minVote = "min_vote", excludeStrings = "exclude_strings",
             excludeUsers = "exclude_users"
    }
    
    static func mergeCommentFilter(_ commentFilterList: [CommentFilter]) -> CommentFilter {
        guard commentFilterList.count > 1 else {
            return commentFilterList.first!
        }

        var commentFilter = CommentFilter()
        commentFilter.name = "Merged"

        for c in commentFilterList {
            // It seems odd but it works lol
            commentFilter.displayMode = DisplayMode(rawValue: max(c.displayMode.rawValue, commentFilter.displayMode.rawValue)) ?? .collapseComment
            commentFilter.maxVote = min(c.maxVote, commentFilter.maxVote)
            commentFilter.minVote = max(c.minVote, commentFilter.minVote)

            if let excludeStrings = c.excludeStrings, !excludeStrings.isEmpty {
                commentFilter.excludeStrings = [
                    commentFilter.excludeStrings ?? "",
                    excludeStrings
                ]
                .filter { !$0.isEmpty }
                .joined(separator: ",")
            }

            if let excludeUsers = c.excludeUsers, !excludeUsers.isEmpty {
                commentFilter.excludeUsers = [
                    commentFilter.excludeUsers ?? "",
                    excludeUsers
                ]
                .filter { !$0.isEmpty }
                .joined(separator: ",")
            }
        }

        return commentFilter
    }
    
    static func isCommentAllowed(_ comment: Comment, _ commentFilter: CommentFilter?) -> Bool {
        guard let commentFilter = commentFilter else {
            return true
        }
        
        if commentFilter.maxVote != -1,
           comment.likes + comment.score > commentFilter.maxVote {
            return false
        }
        
        if commentFilter.minVote != -1,
           comment.likes + comment.score < commentFilter.minVote {
            return false
        }
        
        if let excludeStrings = commentFilter.excludeStrings,
           !excludeStrings.isEmpty {
            let titles = excludeStrings.split(separator: ",", omittingEmptySubsequences: false)
            for t in titles {
                let trimmed = t.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty,
                   comment.bodyHtml.lowercased().contains(trimmed.lowercased()) {
                    return false
                }
            }
        }
        
        if let excludeUsers = commentFilter.excludeUsers,
           !excludeUsers.isEmpty {
            let users = excludeUsers.split(separator: ",", omittingEmptySubsequences: false)
            for u in users {
                let trimmed = u.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty,
                   comment.author.caseInsensitiveCompare(trimmed) == .orderedSame {
                    return false
                }
            }
        }
        
        return true
    }
}
