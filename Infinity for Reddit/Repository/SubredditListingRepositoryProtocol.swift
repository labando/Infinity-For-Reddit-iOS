//
//  SubredditListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-19.
//

import Combine

public protocol SubredditListingRepositoryProtocol {
    func fetchSubredditListing(queries: [String: String]) async throws -> SubredditListing
}
