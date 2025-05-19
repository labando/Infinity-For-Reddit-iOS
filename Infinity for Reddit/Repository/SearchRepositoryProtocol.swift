//
//  SearchRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-18.
//

public protocol SearchRepositoryProtocol {
    func saveSearchQuery(username: String, query: String, searchInSubredditOrUserName: String?, multiRedditPath: String?, searchInThingType: Int, time: Int64)
    func clearAllRecentSearchQueries(username: String)
}
