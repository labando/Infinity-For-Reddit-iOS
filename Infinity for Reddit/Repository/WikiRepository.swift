//
//  WikiRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-25.
//

import SwiftyJSON
import Alamofire

class WikiRepository: WikiRepositoryProtocol {
    private let session: Session
    
    init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session in WikiRepository")
        }
        self.session = resolvedSession
    }
    
    func fetchWiki(subredditName: String, wikiPath: String) async throws -> String {
        let response = await self.session.request(RedditOAuthAPI.getWikiPage(subredditName: subredditName, wikiPage: wikiPath))
            .serializingData(automaticallyCancelling: true)
            .response
        
        guard let statusCode = response.response?.statusCode, let data = response.data else {
            throw APIError.networkError("Cannot fetch wiki page. No data available.")
        }

        if (200...299).contains(statusCode) {
            let json = JSON(data)
            if let error = json.error {
                throw APIError.jsonDecodingError(error.localizedDescription)
            }
            
            return try json["data"]["content_md"].stringValue
        } else if statusCode == 403 || statusCode == 404 {
            // No wiki page
            return ""
        } else {
            throw APIError.networkError("Cannot fetch wiki page.")
        }
    }
}
