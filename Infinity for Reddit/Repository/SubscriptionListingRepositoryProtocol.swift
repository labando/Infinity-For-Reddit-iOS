//
//  SubscriptionListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-15.
//

import Combine
import Alamofire

public protocol SubscriptionListingRepositoryProtocol {
    func fetchSubscriptions(queries: [String: String]) -> AnyPublisher<SubscriptionListing, Error>
    func fetchMyCustomFeeds() -> AnyPublisher<MyCustomFeedListing, Error>
}
