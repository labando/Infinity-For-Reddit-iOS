//
//  RedditAccessTokenProviderExt.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-13.
//

import Alamofire

extension RedditAccessTokenProvider {
    func getRedditPerAccountInterceptor(account: Account) -> RequestInterceptor {
        let username = account.username
        return RedditPerAccountAccessTokenInterceptor(
            getToken: { await self.currentAccessToken(for: username) },
            refreshToken: { try await self.forceRefresh(for: username) }
        )
    }
}
