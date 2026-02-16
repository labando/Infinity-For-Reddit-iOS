//
// RedditAccessTokenProvider.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-14
        
import Foundation
import Alamofire

public actor RedditAccessTokenProvider: RedditAccessTokenProviderProtocol {
    public static let shared = RedditAccessTokenProvider()
    
    private var inFlight: [String: Task<String, Error>] = [:]
    
    enum RedditAccessTokenProviderError: LocalizedError {
        case missingRefreshToken(accountName: String)
        
        var errorDescription: String? {
            switch self {
            case .missingRefreshToken(let accountName):
                return "Missing refresh token for \(accountName)"
            }
        }
    }
    
    private init() {}
    
    public func getAccessToken(accountName: String) -> String? {
        return try? RedditAccessTokenKeychainManager.shared.getAccessToken(accountName: accountName)
    }
    
    @discardableResult
    public func refreshAccessToken(accountName: String) async throws -> String {
        if let existing = inFlight[accountName] {
            return try await existing.value
        }
        let task = Task {
            try await self.refreshAccessTokenTask(for: accountName)
        }
        inFlight[accountName] = task
        defer {
            inFlight[accountName] = nil
        }
        return try await task.value
    }
    
    private func refreshAccessTokenTask(for username: String) async throws -> String {
        guard let refreshToken = try? RedditAccessTokenKeychainManager.shared.getRefreshToken(accountName: username), !refreshToken.isEmpty else {
            throw RedditAccessTokenProviderError.missingRefreshToken(accountName: username)
        }
        
        struct AccessTokenResponse: Decodable {
            let accessToken: String
            let refreshToken: String?
            
            enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case refreshToken = "refresh_token"
            }
        }
        
        let refreshSession = ProxyUtils.makeSession()
        let result = await refreshSession.request(
            "https://www.reddit.com/api/v1/access_token",
            method: .post,
            parameters: ["grant_type": "refresh_token", "refresh_token": refreshToken],
            encoding: URLEncoding.default,
            headers: APIUtils.getHttpBasicAuthHeader()
        )
        .validate()
        .serializingDecodable(AccessTokenResponse.self)
        .result
        
        switch result {
        case .success(let response):
            try? RedditAccessTokenKeychainManager.shared.saveAccessToken(accountName: username, accessToken: response.accessToken)
            if let refreshToken = response.refreshToken, !refreshToken.isEmpty {
                try? RedditAccessTokenKeychainManager.shared.saveRefreshToken(accountName: username, refreshToken: refreshToken)
            }
            return response.accessToken
        case .failure(let error):
            throw error
        }
    }
}
