//
//  SessionProvider.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-21.
//

import Alamofire
import Foundation

class SessionProvider {
    static func getAccountSpecificSession(account: Account) -> Session {
        let username = account.username
        let provider = TokenCenter.shared
        let configuration = URLSessionConfiguration.af.default
        return Session(
            configuration: configuration,
            interceptor: RedditPerAccountAccessTokenInterceptor(
                getToken: { await provider.currentAccessToken(for: username) },
                refreshToken: { try await provider.forceRefresh(for: username) }
            )
        )
    }
}
