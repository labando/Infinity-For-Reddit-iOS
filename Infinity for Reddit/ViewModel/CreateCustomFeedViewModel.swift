//
//  CreateCustomFeedViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import Foundation

class CreateCustomFeedViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var subredditsAndUsersInCustomFeed: [SubredditAndUserInCustomFeed] = []
    @Published var createCustomFeedTask: Task<Void, Never>?
    @Published var customFeedCreatedFlag: Bool = false
    @Published var error: Error? = nil
    
    private let createCustomFeedRepository: CreateCustomFeedRepositoryProtocol
    
    init(createCustomFeedRepository: CreateCustomFeedRepositoryProtocol) {
        self.createCustomFeedRepository = createCustomFeedRepository
    }
    
    func addSubredditsAndUsersInCustomFeed(newValues: [SubredditAndUserInCustomFeed]) {
        for newValue in newValues {
            if !subredditsAndUsersInCustomFeed.contains(where: { $0.name == newValue.name }) {
                subredditsAndUsersInCustomFeed.append(newValue)
            }
        }
    }
}
