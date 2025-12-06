//
//  HistoryPostListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-03.
//

import Combine
import Alamofire

public protocol HistoryPostListingRepositoryProtocol {
    func fetchPosts(historyPostListingType: HistoryPostListingType, username: String, before: Int64?) async throws -> HistoryPostListingResult
    func getPostFilter(historyPostListingType: HistoryPostListingType, externalPostFilter: PostFilter?) async -> PostFilter
    func loadIcon(post: Post) async throws
    func toggleHidePost(_ post: Post) async throws
    func toggleHidePostAnonymous(_ post: Post) async throws
}

public struct HistoryPostListingResult {
    let postListing: PostListing
    let before: Int64
}
