//
//  CommentFilterViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

import GRDB
import Foundation
import Combine

@MainActor
class CommentFilterViewModel: ObservableObject {
    // MARK: - Properties
    @Published var commentFilters: [CommentFilter] = []
    @Published var error: Error?
    
    let commentToBeAdded: Comment?
    private let commentFilterRepository: CommentFilterRepositoryProtocol
    private let commentFilterDao: CommentFilterDao
    
    private let commentFilterUsagesPublisher: AnyPublisher<[CommentFilter], Error>
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(commentToBeAdded: Comment?, commentFilterRepository: CommentFilterRepositoryProtocol) {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.commentToBeAdded = commentToBeAdded
        self.commentFilterRepository = commentFilterRepository
        self.commentFilterDao = CommentFilterDao(dbPool: resolvedDBPool)
        self.commentFilterUsagesPublisher = commentFilterDao.getAllCommentFiltersLiveData()
        
        commentFilterUsagesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] commentFilters in
                self?.commentFilters = commentFilters
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    func deleteCommentFilter(id: Int) {
        Task {
            do {
                try await commentFilterRepository.deleteCommentFilter(id: id)
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
}
