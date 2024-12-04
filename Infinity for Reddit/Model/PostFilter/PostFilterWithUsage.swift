//
// PostFilterWithUsage.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import GRDB

struct PostFilterWithUsage: Codable, FetchableRecord {
    var postFilter: PostFilter
    var postFilterUsages: [PostFilterUsage]
}
