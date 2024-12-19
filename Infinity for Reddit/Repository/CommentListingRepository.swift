//
//  CommentListingRepository.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-15.
//  

import Combine
import Alamofire
import SwiftyJSON
import Foundation

public class CommentListingRepository: CommentListingRepositoryProtocol {

    enum CommentListingRepositoryError: Error {
        case NetworkError(String)
        case JSONDecodingError(String)
    }
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    public func fetchComments(
        commentListingType: CommentListingType,
        pathComponents: [String: String]? = nil,
        queries: [String: String]? = [:],
        params: [String: String]? = [:]
    ) -> AnyPublisher<CommentListing, any Error> {
        
        let apiRequest: URLRequestConvertible
        switch commentListingType {
        case .user:
            apiRequest = RedditOAuthAPI.getUserComments(pathComponents: pathComponents!, queries: queries!)
        }
        
        return Future<CommentListing, any Error> { promise in
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
                                throw CommentListingRepositoryError.JSONDecodingError(error.localizedDescription)
                            } else {
                                let commentListingRootClass = CommentListingRootClass(fromJson: json)
                                promise(.success(commentListingRootClass.data))
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
