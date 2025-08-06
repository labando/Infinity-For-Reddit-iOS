//
//  CommentFilterItemViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

import Foundation
import Combine
import GRDB

class CommentFilterItemViewModel: ObservableObject {
    @Published var commentFilter: CommentFilter
    @Published var commentFilterUsages: [CommentFilterUsage] = []
    
    private let commentFilterUsagesPublisher: AnyPublisher<[CommentFilterUsage], Error>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(commentFilter: CommentFilter) {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.commentFilter = commentFilter
        self.commentFilterUsagesPublisher = CommentFilterUsageDao(dbPool: resolvedDBPool).getAllCommentFilterUsageLiveData(commentFilterId: commentFilter.id ?? -1)
        
        commentFilterUsagesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] commentFilterUsages in
                self?.commentFilterUsages = commentFilterUsages
            })
            .store(in: &cancellables)
    }
}
