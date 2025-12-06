//
//  CommentFilterUsageListingViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

import Foundation
import GRDB
import Combine

@MainActor
class CommentFilterUsageListingViewModel: ObservableObject {
    @Published var commentFilterUsages: [CommentFilterUsage] = []
    @Published var error: Error?
    
    private let commentFilterId: Int
    private let commentFilterUsageListingRepository: CommentFilterUsageListingRepositoryProtocol
    private let commentFilterUsageDao: CommentFilterUsageDao
    
    private var listener: AnyDatabaseCancellable?
    
    private let commentFilterUsagesPublisher: AnyPublisher<[CommentFilterUsage], Error>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(commentFilterId: Int, commentFilterUsageListingRepository: CommentFilterUsageListingRepositoryProtocol) {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.commentFilterId = commentFilterId
        self.commentFilterUsageListingRepository = commentFilterUsageListingRepository
        self.commentFilterUsageDao = CommentFilterUsageDao(dbPool: resolvedDBPool)
        self.commentFilterUsagesPublisher = commentFilterUsageDao.getAllCommentFilterUsageLiveData(commentFilterId: commentFilterId)
        
        commentFilterUsagesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] commentFilterUsages in
                self?.commentFilterUsages = commentFilterUsages
            })
            .store(in: &cancellables)
    }
    
    func saveCommentFilterUsage(usageType: CommentFilterUsage.UsageType, nameOfUsage: String) {
        Task {
            let commentFilterUsage = CommentFilterUsage(commentFilterId: commentFilterId, usageType: usageType, nameOfUsage: nameOfUsage)
            do {
                try await commentFilterUsageListingRepository.saveCommentFilterUsage(commentFilterUsage)
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func deleteCommentFilterUsage(_ commentFilterUsage: CommentFilterUsage) {
        Task {
            do {
                try await commentFilterUsageListingRepository.deleteCommentFilterUsage(commentFilterUsage)
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
}
