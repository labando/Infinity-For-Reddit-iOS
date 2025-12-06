//
//  CustomizeCommentFilterRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

import GRDB

public class CustomizeCommentFilterRepository: CustomizeCommentFilterRepositoryProtocol {
    private let commentFilterDao: CommentFilterDao
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.commentFilterDao = CommentFilterDao(dbPool: resolvedDBPool)
    }
    
    public func saveCommentFilter(_ commentFilter: CommentFilter) async throws {
        if commentFilter.id != nil {
            // Updating a comment filter
            try await commentFilterDao.updateCommentFilter(updatedCommentFilter: commentFilter)
        } else {
            try await commentFilterDao.insert(commentFilter: commentFilter)
        }
    }
}
