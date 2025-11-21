//
//  CreateOrEditCustomFeedRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import IdentifiedCollections

protocol CreateOrEditCustomFeedRepositoryProtocol {
    func createCustomFeed(name: String, description: String, isPrivate: Bool, subredditsAndUsersInCustomFeed: IdentifiedArrayOf<Thing>) async throws -> MyCustomFeed
}
