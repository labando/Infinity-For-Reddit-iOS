//
// SubredditDetailsRepository.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-05-02
        
import Combine
import Alamofire
import SwiftyJSON
import Foundation

public class SubredditDetailsRepository: SubredditDetailsRepositoryProtocol {
    enum SubredditDetailsRepositoryError: Error {
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
    
    public func fetchSubredditDetails(subredditName: String) async throws -> SubredditData {
        let data = try await self.session.request(
            RedditAPI.getSubredditData(subredditName: subredditName)
        )
        .validate()
        .serializingData()
        .value
        
        let json = JSON(data)
        if let error = json.error {
            throw SubredditDetailsRepositoryError.JSONDecodingError(error.localizedDescription)
        }
        
        return SubredditDetailRootClass(fromJson: json).toSubredditData()
    }
    
    public func subsribeSubreddit(subredditName: String, action: String) async throws {
        let params = ["action": action, "sr_name": "r_\(subredditName)"]
    }
}
