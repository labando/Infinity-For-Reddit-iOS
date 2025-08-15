//
// RedditPerAccountAccessTokenInterceptor.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-14
        
import Alamofire
import Foundation

final class RedditPerAccountAccessTokenInterceptor: RequestInterceptor {
    private let getToken: @Sendable() async -> String?
    private let refreshToken: @Sendable() async throws -> String
    
    init(getToken: @escaping @Sendable() async -> String?, refreshToken: @escaping @Sendable () async throws -> String) {
        self.getToken = getToken
        self.refreshToken = refreshToken
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var req = urlRequest
        Task {
            defer { completion(.success(req)) }
            
            guard req.url?.host == "oauth.reddit.com" else {
                if req.headers[APIUtils.USER_AGENT_KEY] == nil {
                    req.headers.add(name: APIUtils.USER_AGENT_KEY, value: APIUtils.USER_AGENT)
                }
                return
            }
            
            if let accessToken = await getToken(), !accessToken.isEmpty {
                req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                req.headers.remove(name: "Authorization")
            }
            
            if req.headers[APIUtils.USER_AGENT_KEY] == nil {
                req.headers.add(name: APIUtils.USER_AGENT_KEY, value: APIUtils.USER_AGENT)
            }
        }
        print(req.url?.absoluteString ?? "Empty URL?")
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount == 0, let http = request.response, http.statusCode == 401 else {
            return completion(.doNotRetryWithError(error))
        }
        
        Task {
            let headerToken = request.request?.value(forHTTPHeaderField: "Authorization") ?? ""
            let current = await getToken() ?? ""
            if !current.isEmpty, headerToken.contains(current) == false {
                return completion(.retry) 
            }
            
            do {
                _ = try await refreshToken()
                completion(.retry)
            } catch {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
