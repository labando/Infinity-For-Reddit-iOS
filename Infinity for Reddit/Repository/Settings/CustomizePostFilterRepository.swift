//
//  CustomizePostFilterRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-01.
//

import GRDB

public class CustomizePostFilterRepository: CustomizePostFilterRepositoryProtocol {
    private let postFilterDao: PostFilterDao
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool in CustomizePostFilterRepository")
        }
        self.postFilterDao = PostFilterDao(dbPool: resolvedDBPool)
    }
    
    public func savePostFilter(_ postFilter: PostFilter) async throws {
        if postFilter.id != nil {
            // Updating a post filter
            try await postFilterDao.updatePostFilter(updatedPostFilter: postFilter)
        } else {
            try await postFilterDao.insert(postFilter: postFilter)
        }
    }
}
