//
//  CommentFilterRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

import GRDB

public class CommentFilterRepository: CommentFilterRepositoryProtocol {
    private let commentFilterDao: CommentFilterDao
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.commentFilterDao = CommentFilterDao(dbPool: resolvedDBPool)
    }
    
    public func deleteCommentFilter(id: Int) async throws {
        try await commentFilterDao.deleteCommentFilter(id: id)
    }
}
