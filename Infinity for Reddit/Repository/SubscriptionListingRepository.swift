//
//  SubscriptionListingRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-15.
//

import Combine
import Alamofire
import SwiftyJSON
import Foundation
import GRDB

class SubscriptionListingRepository: SubscriptionListingRepositoryProtocol {
    enum SubscriptionListingRepositoryError: Error {
        case NetworkError(String)
        case JSONDecodingError(String)
    }
    private let session: Session
    private let subscribedSubredditDao: SubscribedSubredditDao
    private let subscribedUserDao: SubscribedUserDao
    private let myCustomFeedDao: MyCustomFeedDao
    
    public init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.session = resolvedSession
        self.subscribedSubredditDao = SubscribedSubredditDao(dbPool: resolvedDBPool)
        self.subscribedUserDao = SubscribedUserDao(dbPool: resolvedDBPool)
        self.myCustomFeedDao = MyCustomFeedDao(dbPool: resolvedDBPool)
    }
    
    public func fetchSubscriptions(
        queries: [String: String] = [:]
    ) async throws -> SubscriptionListing {
        let data = try await self.session.request(
            RedditOAuthAPI.getSubscribedThings(queries: queries)
        )
            .validate()
            .serializingData()
            .value
        
        let json = JSON(data)
        if let error = json.error {
            throw SubscriptionListingRepositoryError.JSONDecodingError(error.localizedDescription)
        }
        
        // TODO need to handle JSON error
        return SubscriptionListingRootClass(fromJson: json).subscriptionListing
    }
    
    public func fetchMyCustomFeeds() async throws -> MyCustomFeedListing {
        let data = try await self.session.request(
            RedditOAuthAPI.getMyCustomFeeds
        )
            .validate()
            .serializingData()
            .value
        
        let json = JSON(data)
        if let error = json.error {
            throw SubscriptionListingRepositoryError.JSONDecodingError(error.localizedDescription)
        }
        
        return MyCustomFeedListing(fromJson: json)
    }
    
    func toggleFavoriteSubreddit(_ subscribedSubreddit: SubscribedSubredditData) -> Bool {
        do {
            try subscribedSubredditDao.insert(subscribedSubredditData: subscribedSubreddit)
            return true
        } catch {
            print("Failed to toggle favorite subreddit: \(error)")
            return false
        }
    }
    
    func toggleFavoriteUser(_ subscribedUser: SubscribedUserData) -> Bool {
        do {
            try subscribedUserDao.insert(subscribedUserData: subscribedUser)
            return true
        } catch {
            print("Failed to toggle favorite user: \(error)")
            return false
        }
    }
    
    func toggleFavoriteCustomFeed(_ myCustomFeed: MyCustomFeed) -> Bool {
        do {
            try myCustomFeedDao.insert(myCustomFeed: myCustomFeed)
            return true
        } catch {
            print("Failed to toggle favorite custom feed: \(error)")
            return false
        }
    }
}
