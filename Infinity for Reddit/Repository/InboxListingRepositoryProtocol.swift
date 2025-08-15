//
//  InboxListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-23.
//

import Alamofire

public protocol InboxListingRepositoryProtocol {
    func fetchInboxListing(messageWhere: MessageWhere, pathComponents: [String : String], queries: [String : String], interceptor: RequestInterceptor?) async throws -> InboxListing
}
