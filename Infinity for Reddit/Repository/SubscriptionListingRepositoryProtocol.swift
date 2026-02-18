//
//  SubscriptionListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-15.
//

import Combine
import Alamofire

protocol SubscriptionListingRepositoryProtocol {
    func fetchSubscriptions(queries: [String: String]) async throws -> SubscriptionListing?
    func fetchMyCustomFeeds() async throws -> MyCustomFeedListing?
    func toggleFavoriteSubreddit(_ subscribedSubreddit: SubscribedSubredditData) async throws
    func toggleFavoriteUser(_ subscribedUser: SubscribedUserData) async throws
    func toggleFavoriteCustomFeed(_ customFeed: MyCustomFeed) async throws
    func unsubscribeFromSubreddit(_ subscribedSubreddit: SubscribedSubredditData) async throws
    func unfollowUser(_ subscribedUser: SubscribedUserData) async throws
    func deleteCustomFeed(_ customFeed: MyCustomFeed) async throws
}
