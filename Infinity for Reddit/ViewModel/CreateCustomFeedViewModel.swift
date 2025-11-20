//
//  CreateCustomFeedViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import Foundation
import IdentifiedCollections

class CreateCustomFeedViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var subredditsAndUsersInCustomFeed: IdentifiedArrayOf<SubredditAndUserInCustomFeed> = []
    @Published var createCustomFeedTask: Task<Void, Never>?
    @Published var customFeedCreatedFlag: Bool = false
    @Published var error: Error? = nil
    
    private let createCustomFeedRepository: CreateCustomFeedRepositoryProtocol
    
    init(createCustomFeedRepository: CreateCustomFeedRepositoryProtocol) {
        self.createCustomFeedRepository = createCustomFeedRepository
    }
    
    func addSubredditsAndUsersInCustomFeed(_ newValues: [SubredditAndUserInCustomFeed]) {
        for newValue in newValues {
            if subredditsAndUsersInCustomFeed.index(id: newValue.id) == nil {
                subredditsAndUsersInCustomFeed.append(newValue)
            }
        }
    }
    
    func removeSubredditAndUserInCustomFeed(_ value: SubredditAndUserInCustomFeed) {
        subredditsAndUsersInCustomFeed.remove(value)
    }
}
