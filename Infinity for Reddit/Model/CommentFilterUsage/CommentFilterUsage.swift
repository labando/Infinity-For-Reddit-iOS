//
// CommentFilterUsage.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import GRDB

public struct CommentFilterUsage: Codable, FetchableRecord, PersistableRecord, Hashable {
    public static let databaseTableName: String = "comment_filter_usage"
    
    public enum UsageType: Int, Codable {
        case subreddit = 1
        
        var description: String {
            switch self {
            case .subreddit:
                return "Subreddit"
            }
        }
        
        var textFieldPlaceholder: String {
            switch self {
            case .subreddit:
                return "Subreddit Name (Without r/ prefix)"
            }
        }
    }

    var commentFilterId: Int
    var usageType: UsageType
    var nameOfUsage: String
    
    var description: String {
        switch self.usageType {
        case .subreddit:
            if nameOfUsage == PostFilterUsage.NO_USAGE {
                return "All subreddits"
            }
            return "r/" + nameOfUsage
        }
    }

    init(commentFilterId: Int, usageType: UsageType, nameOfUsage: String) {
        self.commentFilterId = commentFilterId
        self.usageType = usageType
        self.nameOfUsage = nameOfUsage
    }

    private enum CodingKeys: String, CodingKey, ColumnExpression {
        case commentFilterId = "comment_filter_id", usageType = "usage_type", nameOfUsage = "name_of_usage"
    }
}




