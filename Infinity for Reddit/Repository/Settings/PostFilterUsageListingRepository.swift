//
//  PostFilterUsageRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-03.
//

import GRDB

public class PostFilterUsageListingRepository: PostFilterUsageListingRepositoryProtocol {
    private let postFilterUsageDao: PostFilterUsageDao
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.postFilterUsageDao = PostFilterUsageDao(dbPool: resolvedDBPool)
    }
    
    public func savePostFilterUsage(_ postFilterUsage: PostFilterUsage) async throws {
        try await postFilterUsageDao.insert(postFilterUsage: postFilterUsage)
    }
    
    public func deletePostFilterUsage(_ postFilterUsage: PostFilterUsage) async throws {
        try await postFilterUsageDao.deletePostFilterUsage(postFilterUsage: postFilterUsage)
    }
}
