//
//  RedgifsAccessTokenInterceptor.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-15.
//

import Alamofire
import Combine
import Foundation

final class RedgifsAccessTokenInterceptor: RequestInterceptor {
    private let lock = NSLock()
    private let refreshTokenSession: Session = ProxyUtils.makeSession()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard var url = urlRequest.url else {
            return completion(.success(urlRequest))
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue("bearer \(TokenUserDefaultsUtils.redgifs)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(APIUtils.USER_AGENT, forHTTPHeaderField: APIUtils.USER_AGENT_KEY)
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount == 0 else { return completion(.doNotRetry) }
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetryWithError(error))
        }
        
        if let afError = error as? AFError {
            switch afError {
            case .responseValidationFailed:
                break
            default:
                return completion(.doNotRetry)
            }
        }
        
        lock.lock()
        
        let tokenInUserDefaults = TokenUserDefaultsUtils.redgifs
        if !tokenInUserDefaults.isEmpty && request.request?.value(forHTTPHeaderField: "Authorization")?.contains(tokenInUserDefaults) != true {
            lock.unlock()
            return completion(.retry)
        }
        
        refreshAccessToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                TokenUserDefaultsUtils.setRedgifs(token)
                /// After updating the token we can safely retry the original request.
                completion(.retry)
                self.lock.unlock()
            case .failure(let error):
                completion(.doNotRetryWithError(error))
                self.lock.unlock()
            }
        }
    }
    
    // MARK: - Refresh the access token
    func refreshAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = ["User-Agent": APIUtils.USER_AGENT]
        
        refreshTokenSession.request("https://api.redgifs.com/v2/auth/temporary", method: .get, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: AccessTokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    completion(.success(tokenResponse.token))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    struct AccessTokenResponse: Decodable {
        let token: String
        
        enum CodingKeys: String, CodingKey {
            case token = "token"
        }
    }
}
