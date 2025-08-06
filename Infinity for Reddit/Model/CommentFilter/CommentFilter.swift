//
// CommentFilter.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import GRDB

struct CommentFilter: Codable, FetchableRecord, PersistableRecord, Hashable {
    static let databaseTableName = "comment_filter"

    var id: Int?
    var name: String = "New Filter"

    var displayMode: Int = 0

    var maxVote: Int = -1
    var minVote: Int = -1
    var excludeStrings: String?
    var excludeUsers: String?

    init() { }

    private enum CodingKeys: String, CodingKey, ColumnExpression {
        case id, name, displayMode = "display_mode", maxVote = "max_vote",
             minVote = "min_vote", excludeStrings = "exclude_strings",
             excludeUsers = "exclude_users"
    }
}
