//
//  PostFilterItemViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-05.
//

import Foundation
import Combine
import GRDB

class PostFilterItemViewModel: ObservableObject {
    @Published var postFilter: PostFilter
    @Published var postFilterUsages: [PostFilterUsage] = []
    
    private let postFilterUsagesPublisher: AnyPublisher<[PostFilterUsage], Error>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(postFilter: PostFilter) {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.postFilter = postFilter
        self.postFilterUsagesPublisher = PostFilterUsageDao(dbPool: resolvedDBPool).getAllPostFilterUsageLiveData(postFilterId: postFilter.id ?? -1)
        
        postFilterUsagesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] postFilterUsages in
                self?.postFilterUsages = postFilterUsages
            })
            .store(in: &cancellables)
    }
}
