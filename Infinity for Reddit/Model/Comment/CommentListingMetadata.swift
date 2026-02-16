//
//  CommentListingMetaData.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-15.
//  

import Alamofire

public struct CommentListingMetadata {
    var commentListingType: CommentListingType
    var pathComponents: [String: String]
    var queries: [String: String]?
    
    init(
        commentListingType: CommentListingType,
        pathComponents: [String: String] = [:],
        queries: [String: String]? = nil
    ) {
        self.commentListingType = commentListingType
        self.pathComponents = pathComponents
        self.queries = queries
    }
}

public enum CommentListingType: Codable {
    case user(username: String)
    case userSaved
}
