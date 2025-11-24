//
//  CopyCustomFeedRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import IdentifiedCollections

protocol CopyCustomFeedRepositoryProtocol {
    func fetchCustomFeedDetails(path: String) async throws -> CustomFeed
    func copyCustomFeed(path: String, name: String, description: String, subredditsAndUsersInCustomFeed: IdentifiedArrayOf<Thing>) async throws -> MyCustomFeed
}
