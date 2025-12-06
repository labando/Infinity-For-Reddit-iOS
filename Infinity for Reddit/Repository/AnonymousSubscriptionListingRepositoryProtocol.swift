//
//  AnonymousSubscriptionListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-09.
//

protocol AnonymousSubscriptionListingRepositoryProtocol {
    func toggleFavoriteSubreddit(_ subscribedSubreddit: SubscribedSubredditData) async throws
    func toggleFavoriteUser(_ subscribedUser: SubscribedUserData) async throws
    func toggleFavoriteCustomFeed(_ customFeed: MyCustomFeed) async throws
    func unsubscribeFromSubreddit(_ subscribedSubreddit: SubscribedSubredditData) async throws
    func unfollowUser(_ subscribedUser: SubscribedUserData) async throws
    func deleteCustomFeed(_ myCustomFeed: MyCustomFeed) async throws
}
