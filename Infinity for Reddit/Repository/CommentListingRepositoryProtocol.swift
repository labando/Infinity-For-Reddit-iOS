//
//  CommentListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-15.
//  

import Combine
import Alamofire

public protocol CommentListingRepositoryProtocol {
    func fetchComments(commentListingType: CommentListingType, pathComponents: [String: String]?, queries: [String: String]?, params: [String: String]?) -> AnyPublisher<CommentListing, Error>
}
