//
//  AnonymousSubscriptionListingRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-09.
//

import GRDB

class AnonymousSubscriptionListingRepository: AnonymousSubscriptionListingRepositoryProtocol {
    private let subscribedSubredditDao: SubscribedSubredditDao
    private let subscribedUserDao: SubscribedUserDao
    private let myCustomFeedDao: MyCustomFeedDao
    
    public init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.subscribedSubredditDao = SubscribedSubredditDao(dbPool: resolvedDBPool)
        self.subscribedUserDao = SubscribedUserDao(dbPool: resolvedDBPool)
        self.myCustomFeedDao = MyCustomFeedDao(dbPool: resolvedDBPool)
    }
    
    func toggleFavoriteSubreddit(_ subscribedSubreddit: SubscribedSubredditData) async throws {
        try await subscribedSubredditDao.insert(subscribedSubredditData: subscribedSubreddit)
    }
    
    func toggleFavoriteUser(_ subscribedUser: SubscribedUserData) async throws {
        try await subscribedUserDao.insert(subscribedUserData: subscribedUser)
    }
    
    func toggleFavoriteCustomFeed(_ myCustomFeed: MyCustomFeed) async throws {
        try await myCustomFeedDao.insert(myCustomFeed: myCustomFeed)
    }
    
    func unsubscribeFromSubreddit(_ subscribedSubreddit: SubscribedSubredditData) async throws {
        try await subscribedSubredditDao.deleteSubscribedSubreddit(subredditName: subscribedSubreddit.name, accountName: Account.ANONYMOUS_ACCOUNT.username)
    }
    
    func unfollowUser(_ subscribedUser: SubscribedUserData) async throws {
        try await subscribedUserDao.deleteSubscribedUser(name: subscribedUser.name, accountName: Account.ANONYMOUS_ACCOUNT.username)
    }
    
    func deleteCustomFeed(_ myCustomFeed: MyCustomFeed) async throws {
        try await myCustomFeedDao.deleteMyCustomFeed(path: myCustomFeed.path, username: Account.ANONYMOUS_ACCOUNT.username)
    }
}
