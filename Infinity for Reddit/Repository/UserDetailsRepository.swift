//
//  UserDetailsRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-04.
//

import Combine
import Alamofire
import SwiftyJSON
import Foundation

public class UserDetailsRepository: UserDetailsRepositoryProtocol {
    enum UserDetailsRepositoryError: Error {
        case NetworkError(String)
        case JSONDecodingError(String)
    }
    
    private let session: Session
    
    public init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        self.session = resolvedSession
    }
    
    public func fetchUserDetails(username: String) -> AnyPublisher<UserData, Error> {
        return Future<UserData, any Error> { promise in
            self.session.request(RedditAPI.getUserData(username: username))
                .validate()
                .responseString { response in
                    switch response.result {
                    case .success(let userDataResponse):
                        guard !userDataResponse.isEmpty else {
                            print("Error: Empty response from Reddit")
                            promise(.failure(NSError(domain: "RedditAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response from Reddit"])))
                            return
                        }
                        
                        if let myInfoData = userDataResponse.data(using: .utf8) {
                            do {
                                let jsonResponse = try JSON(data: myInfoData)["data"]
                                
                                let name = jsonResponse[JSONUtils.NAME_KEY].stringValue
                                let iconUrl = jsonResponse[JSONUtils.ICON_IMG_KEY].stringValue
                                let bannerImageUrl = jsonResponse[JSONUtils.SUBREDDIT_KEY][JSONUtils.BANNER_IMG_KEY].string
                                let commentKarma = jsonResponse[JSONUtils.COMMENT_KARMA_KEY].intValue
                                let linkKarma = jsonResponse[JSONUtils.LINK_KARMA_KEY].intValue
                                let awarderKarma = jsonResponse[JSONUtils.AWARDER_KARMA_KEY].intValue
                                let awardeeKarma = jsonResponse[JSONUtils.AWARDEE_KARMA_KEY].intValue
                                let totalKarma = jsonResponse[JSONUtils.TOTAL_KARMA_KEY].intValue
                                let cakeday = jsonResponse[JSONUtils.CREATED_UTC_KEY].doubleValue
                                let isGold = jsonResponse[JSONUtils.IS_GOLD_KEY].boolValue
                                let isFriend = jsonResponse[JSONUtils.IS_FRIEND_KEY].boolValue
                                let canBeFollowed = jsonResponse[JSONUtils.CAN_BE_FOLLOWED_KEY].boolValue
                                let isNSFW = jsonResponse[JSONUtils.OVER_18_KEY].boolValue
                                let description = jsonResponse[JSONUtils.SUBREDDIT_KEY][JSONUtils.ACTIVE_CHATTERS_KEY].stringValue
                                let title = jsonResponse[JSONUtils.SUBREDDIT_KEY][JSONUtils.TITLE_KEY].stringValue
                                
                                let userData = UserData(
                                    name: name,
                                    iconUrl: iconUrl,
                                    banner: bannerImageUrl,
                                    commentKarma: commentKarma,
                                    linkKarma: linkKarma,
                                    awarderKarma: awarderKarma,
                                    awardeeKarma: awardeeKarma,
                                    totalKarma: totalKarma,
                                    cakeday: cakeday,
                                    isGold: isGold,
                                    isFriend: isFriend,
                                    canBeFollowed: canBeFollowed,
                                    isNSFW: isNSFW,
                                    description: description,
                                    title: title
                                )
                                
                                promise(.success(userData))
                                
                            } catch {
                                print("Error: Failed to parse account JSON - \(error.localizedDescription)")
                                promise(.failure(error))
                            }
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    public func followUser(username: String, action: String) -> AnyPublisher<Void, any Error> {
        let params = ["action": action, "sr_name": "u_\(username)"]
        
        return Future<Void, any Error> { promise in
            self.session.request(RedditOAuthAPI.subsrcribeToSubreddit(params: params))
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(_):
                        promise(.success(Void()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
