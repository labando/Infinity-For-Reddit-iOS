//
//  CreateCustomFeedViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import Foundation
import IdentifiedCollections

@MainActor
class CreateCustomFeedViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var isPrivate: Bool = true
    @Published var subredditsAndUsersInCustomFeed: IdentifiedArrayOf<SubredditAndUserInCustomFeed> = []
    @Published var createCustomFeedTask: Task<Void, Never>?
    @Published var createdMyCustomFeed: MyCustomFeed?
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
    
    func createCustomFeed() {
        guard createCustomFeedTask == nil else {
            return
        }
        
        createCustomFeedTask = Task {
            do {
                self.createdMyCustomFeed = try await createCustomFeedRepository.createCustomFeed(
                    name: name,
                    description: description,
                    isPrivate: isPrivate,
                    subredditsAndUsersInCustomFeed: subredditsAndUsersInCustomFeed
                )
            } catch {
                self.error = error
                print(error)
            }
            
            createCustomFeedTask = nil
        }
    }
}
