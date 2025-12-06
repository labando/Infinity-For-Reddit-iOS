//
//  CommentFilterUsageListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

public protocol CommentFilterUsageListingRepositoryProtocol {
    func saveCommentFilterUsage(_ commentFilterUsage: CommentFilterUsage) async throws
    func deleteCommentFilterUsage(_ commentFilterUsage: CommentFilterUsage) async throws
}
