//
//  PostListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-05.
//

import Combine
import Alamofire

public protocol PostListingRepositoryProtocol {
    func fetchPosts(postListingType: PostListingType, pathComponents: [String: String]?, queries: [String: String]?, params: [String: String]?) async throws -> PostListing
    func getAnonymousSubscriptionsConcatenated() async -> String
    func getAnonymousCustomThemeSubredditsConcatenated(myCustomFeed: MyCustomFeed) async -> String
    func getPostFilter(postListingType: PostListingType, externalPostFilter: PostFilter?) async -> PostFilter
    func loadIcon(post: Post) async throws
    func toggleHidePost(_ post: Post) async throws
    func toggleHidePostAnonymous(_ post: Post) async throws
}
