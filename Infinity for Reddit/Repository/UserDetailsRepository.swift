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
        let apiRequest: URLRequestConvertible
        apiRequest = RedditAPI.getUserData(username: username)
        return Future<UserData, any Error> { promise in
            self.session.request(
                apiRequest
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let json = JSON(data)
                        if let error = json.error {
                            throw UserDetailsRepositoryError.JSONDecodingError(error.localizedDescription)
                        } else {
                            let userDetailRootClass = UserDetailRootClass(fromJson: json)
                            promise(.success(userDetailRootClass.toUserData()))
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
