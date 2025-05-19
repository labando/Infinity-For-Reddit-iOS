//
//  SearchInThingType.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-18.
//

public enum SearchInThingType: Int, Codable, CaseIterable, Hashable {
    case all = -1
    case subreddit = 0
    case user = 1
    case multireddit = 2
}
