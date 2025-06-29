//
//  PostDetailsRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-23.
//

import Combine
import Alamofire

public protocol PostDetailsRepositoryProtocol {
    func fetchComments(postId: String, queries: [String: String]) async throws -> PostDetailsRootClass
    func fetchMoreCommentsForCommentMore(params: [String: String]) async throws -> MoreChildren
    func loadPostIcon(post: Post, isFromSubredditPostListing: Bool) async throws
}
