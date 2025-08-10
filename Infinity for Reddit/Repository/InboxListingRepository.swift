//
//  InboxListingRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-23.
//

import Alamofire
import SwiftyJSON
import Foundation

public class InboxListingRepository: InboxListingRepositoryProtocol {
    enum InboxRepositoryError: Error {
        case NetworkError(String)
        case JSONDecodingError(String)
        case AuthRequiredError(String)
    }
    
    private let session: Session
    private let sessionName: String?
    
    public init(sessionName: String? = nil) {
        self.sessionName = sessionName
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self, name: self.sessionName) else {
            fatalError("Failed to resolve Session")
        }
        self.session = resolvedSession
    }
    
    public func fetchInboxListing(messageWhere: MessageWhere, pathComponents: [String : String], queries: [String : String], accessToken: String? = nil) async throws -> InboxListing {
        try Task.checkCancellation()
        
        var path = pathComponents
        path["where"] = messageWhere.rawValue
        
        var headers = HTTPHeaders()
        
        if let token = accessToken, !token.isEmpty {
            headers.add(name: APIUtils.USER_AGENT_KEY, value: APIUtils.USER_AGENT)
            headers.add(name: "Authorization", value: "bearer \(token)")
        } else if sessionName == "plain" {
            throw InboxRepositoryError.AuthRequiredError("Access token is required for inbox/unread with plain session.")
        }
        
        let response = try await self.session.request(
            RedditOAuthAPI.getInbox(pathComponents: path, queries: queries, headers: headers)
        )
        .validate()
        .serializingData()
        .response
        
        if let statusCode = response.response?.statusCode {
            print("Status code: \(statusCode)")
        }
        
        let data = response.data
        
        try Task.checkCancellation()
        
        let json = JSON(data)
        if let error = json.error {
            throw InboxRepositoryError.JSONDecodingError(error.localizedDescription)
        }
        
        return InboxListingRootClass(fromJson: json, messageWhere: messageWhere).data
    }
}
