//
//  SubscriptionListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-15.
//

import Combine
import Alamofire

protocol SubscriptionListingRepositoryProtocol {
    func fetchSubscriptions(queries: [String: String]) async throws -> SubscriptionListing
    func fetchMyCustomFeeds() async throws -> MyCustomFeedListing
    func toggleFavoriteSubreddit(_ subscribedSubreddit: SubscribedSubredditData) -> Bool
    func toggleFavoriteUser(_ subscribedUser: SubscribedUserData) -> Bool
    func toggleFavoriteCustomFeed(_ customFeed: MyCustomFeed) -> Bool
}
