//
// TokenCenter.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-14
        
import Foundation
import Alamofire
import GRDB

public actor TokenCenter: TokenProvider {
    
    public static let shared = TokenCenter()
    private let dbPool: DatabasePool
    private var inFlight: [String: Task<String, Error>] = [:]
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError( "Failed to resolve DatabasePool")
        }
        self.dbPool = resolvedDBPool
    }
    public func currentAccessToken(for username: String) -> String? {
        let accountDao = AccountDao(dbPool: dbPool)
        return try? accountDao.getAccount(username: username)?.accessToken
    }
    
    @discardableResult
    public func forceRefresh(for username: String) async throws -> String {
        if let existing = inFlight[username] {
            return try await existing.value
        }
        let task = Task {
            try await self.refreshToken(for: username)
        }
        inFlight[username] = task
        defer {
            inFlight[username] = nil
        }
        return try await task.value
    }
    
    private func refreshToken(for username: String) async throws -> String {
        let accountDao = AccountDao(dbPool: dbPool)
        guard let account = try? accountDao.getAccount(username: username),
              let refreshToken = account.refreshToken, !refreshToken.isEmpty else {
            throw NSError(domain: "TokenCenter",
                          code: 1001,
                          userInfo: [NSLocalizedDescriptionKey:
                                        "Missing refresh token for \(username)"])
        }
        
        struct AccessTokenResponse: Decodable {
            let accessToken: String
            let refreshToken: String?
            
            enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case refreshToken = "refresh_token"
            }
        }
        
        let refreshSession = Session(configuration: .af.default)
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
            if let newRefreshToken = response.refreshToken {
                try? accountDao.updateAccessTokenAndRefreshToken(username: username,
                                                                 accessToken: response.accessToken,
                                                                 refreshToken: newRefreshToken)
            } else {
                try? accountDao.updateAccessToken(username: username,
                                                  accessToken: response.accessToken)
            }
            
            if AccountViewModel.shared.account.username
                .caseInsensitiveCompare(username) == .orderedSame {
                await MainActor.run {
                    try? AccountViewModel.shared.updateTokens(accessToken: response.accessToken,
                                                              refreshToken: response.refreshToken)
                }
            }
            return response.accessToken
        case .failure(let error):
            throw error
        }
    }
}
