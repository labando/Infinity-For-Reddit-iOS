//
// CommentFilterWithUsage.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import GRDB

struct CommentFilterWithUsage: Codable, FetchableRecord {
    var commentFilter: CommentFilter
    var commentFilterUsageList: [CommentFilterUsage]
}
