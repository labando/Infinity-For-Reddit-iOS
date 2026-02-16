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
            getAccessToken: { await self.getAccessToken(accountName: username) },
            refreshAccessToken: { try await self.refreshAccessToken(accountName: username) }
        )
    }
}
