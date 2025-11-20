//
//  CreateCustomFeedRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import IdentifiedCollections

protocol CreateCustomFeedRepositoryProtocol {
    func createCustomFeed(name: String, description: String, isPrivate: Bool, subredditsAndUsersInCustomFeed: IdentifiedArrayOf<SubredditAndUserInCustomFeed>) async throws -> MyCustomFeed
}
