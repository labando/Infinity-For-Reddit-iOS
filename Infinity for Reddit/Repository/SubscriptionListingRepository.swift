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

public class SubscriptionListingRepository: SubscriptionListingRepositoryProtocol {
    enum SubscriptionListingRepositoryError: Error {
        case NetworkError(String)
        case JSONDecodingError(String)
    }
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    public func fetchSubscriptions(
        queries: [String: String] = [:]
    ) -> AnyPublisher<SubscriptionListing, any Error> {
        return Future<SubscriptionListing, any Error> { promise in
            self.session.request(
                RedditOAuthAPI.getSubscribedThings(queries: queries)
            )
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let json = JSON(data)
                            if let error = json.error {
                                throw SubscriptionListingRepositoryError.JSONDecodingError(error.localizedDescription)
                            } else {
                                let subscriptionListingRootClass = SubscriptionListingRootClass(fromJson: json)
                                promise(.success(subscriptionListingRootClass.subscriptionListing))
                            }
                        } catch {
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    public func fetchMyCustomFeeds() -> AnyPublisher<MyCustomFeedListing, any Error> {
        return Future<MyCustomFeedListing, any Error> { promise in
            self.session.request(
                RedditOAuthAPI.getMyCustomFeeds
            )
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let json = JSON(data)
                            if let error = json.error {
                                throw SubscriptionListingRepositoryError.JSONDecodingError(error.localizedDescription)
                            } else {
                                let myCustomFeedListing = MyCustomFeedListing(fromJson: json)
                                promise(.success(myCustomFeedListing))
                            }
                        } catch {
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
