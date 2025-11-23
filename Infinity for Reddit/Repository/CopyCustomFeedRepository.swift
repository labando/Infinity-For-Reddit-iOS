//
//  CopyCustomFeedRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import Alamofire
import GRDB
import SwiftyJSON
import IdentifiedCollections
import Foundation

class CopyCustomFeedRepository: CopyCustomFeedRepositoryProtocol {
    enum CopyCustomFeedRepositoryError: LocalizedError {
        case duplicateAnonymousCustomFeed
        
        var errorDescription: String? {
            switch self {
            case .duplicateAnonymousCustomFeed:
                return "A custom feed with the same name already exists."
            }
        }
    }
    
    private let session: Session
    private let myCustomFeedDao: MyCustomFeedDao
    private let anonymousCustomFeedSubredditDao: AnonymousCustomFeedSubredditDao
    
    public init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session in CopyCustomFeedRepository")
        }
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError( "Failed to resolve DatabasePool in CopyCustomFeedRepository")
        }
        self.session = resolvedSession
        self.myCustomFeedDao = MyCustomFeedDao(dbPool: resolvedDBPool)
        self.anonymousCustomFeedSubredditDao = AnonymousCustomFeedSubredditDao(dbPool: resolvedDBPool)
    }
    
    func fetchCustomFeedDetails(path: String) async throws -> CustomFeed {
        let queries = ["multipath": path]
        
        try Task.checkCancellation()
        
        let data = try await self.session.request(RedditOAuthAPI.getCustomFeedInfo(queries: queries))
            .validate()
            .serializingData()
            .value
        
        let json = JSON(data)
        if let error = json.error {
            throw APIError.jsonDecodingError(error.localizedDescription)
        }
        
        return try CustomFeed(fromJson: json["data"])
    }
    
    func copyCustomFeed(path: String, name: String, description: String, subredditsAndUsersInCustomFeed: IdentifiedArrayOf<Thing>) async throws -> MyCustomFeed {
        guard !AccountViewModel.shared.account.isAnonymous() else {
            return try await copyCustomFeedAnonymous(name: name, description: description, subredditsAndUsersInCustomFeed: subredditsAndUsersInCustomFeed)
        }

        let params: [String: String] = [
            "from": path,
            "display_name": name,
            "description_md": description
        ]
        
        let response = await self.session.request(RedditOAuthAPI.copyCustomFeed(params: params))
            .serializingData(automaticallyCancelling: true)
            .response
        
        guard let statusCode = response.response?.statusCode, let data = response.data else {
            throw APIError.networkError("Cannot copy this custom feed.")
        }

        if (200...299).contains(statusCode) {
            let json = JSON(data)
            if let error = json.error {
                throw APIError.jsonDecodingError(error.localizedDescription)
            }
            
            let copiedMyCustomFeed = try CustomFeed(fromJson: json["data"]).toMyCustomFeed()
            
            try? myCustomFeedDao.insert(myCustomFeed: copiedMyCustomFeed)
            
            return copiedMyCustomFeed
        } else {
            if let customFeedCreationError = try? CustomFeedCreationError(fromJson: JSON(data)) {
                throw APIError.invalidResponse(customFeedCreationError.explanation.capitalizedFirst)
            } else {
                throw APIError.networkError("Cannot copy this custom feed.")
            }
        }
    }
    
    private func copyCustomFeedAnonymous(name: String, description: String, subredditsAndUsersInCustomFeed: IdentifiedArrayOf<Thing>) async throws -> MyCustomFeed {
        let myCustomFeed = MyCustomFeed(
            path: "/user/-/m/\(name)",
            displayName: name,
            name: name,
            description: description,
            owner: "-",
            nSubscribers: 0,
            createdUTC: Utils.getCurrentTimeEpoch(),
            over18: false,
            isSubscriber: false,
            isFavorite: false
        )
        guard try myCustomFeedDao.getMyCustomFeed(path: myCustomFeed.path, username: Account.ANONYMOUS_ACCOUNT.username) == nil else {
            throw CopyCustomFeedRepositoryError.duplicateAnonymousCustomFeed
        }
        
        try myCustomFeedDao.insert(myCustomFeed: myCustomFeed)
        
        let anonymousCustomFeedSubreddits: [AnonymousCustomFeedSubreddit] = subredditsAndUsersInCustomFeed.map {
            AnonymousCustomFeedSubreddit(
                path: myCustomFeed.path,
                subredditName: $0.name,
                iconUrlString: $0.iconUrlString ?? ""
            )
        }
        
        do {
            try anonymousCustomFeedSubredditDao.insertAll(anonymousMultiredditSubreddits: anonymousCustomFeedSubreddits)
        } catch {
            // Ugly
            print(error)
            try myCustomFeedDao.anonymousDeleteMyCustomFeed(path: myCustomFeed.path)
        }
        
        return myCustomFeed
    }
}
