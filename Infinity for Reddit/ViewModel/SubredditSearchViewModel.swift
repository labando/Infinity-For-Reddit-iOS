//
//  SubredditSearchViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-09-06.
//

import Foundation
import Combine
import GRDB

class SubredditSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var recentSearchQueries: [RecentSearchQuery] = []
    
    private let dbPool: DatabasePool
    private let searchRepository: SearchRepository
    
    private let username: String
    private let recentSearchQueriesPublisher: AnyPublisher<[RecentSearchQuery], Error>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(username: String) {
        guard let resolvedOperationQueue = DependencyManager.shared.container.resolve(OperationQueue.self) else {
            fatalError("Could not resolve OperationQueue")
        }
        
        guard let resolvedDatabasePool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Could not resolve DatabasePool")
        }
        
        self.username = username
        self.dbPool = resolvedDatabasePool
        
        let recentSearchQueryDao = RecentSearchQueryDao(dbPool: dbPool)
        self.searchRepository = SearchRepository(recentSearchQueryDao: recentSearchQueryDao, operationQueue: resolvedOperationQueue)
        recentSearchQueriesPublisher = recentSearchQueryDao.getAllRecentSearchQueriesLiveData(username: username)
        
        receiveRecentSearchQueries()
    }
    
    private func receiveRecentSearchQueries() {
        recentSearchQueriesPublisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished successfully.")
                case .failure(let error):
                    print("Encountered an error: \(error)")
                }
            },
            receiveValue: { result in
                self.recentSearchQueries = result
            }
        )
        .store(in: &cancellables)
    }
    
    func saveSearchQuery() {
        searchRepository.saveSearchQuery(username: username, query: query, searchInSubredditOrUserName: nil, multiRedditPath: nil, searchInThingType: SearchInThingType.all.rawValue, time: Int64(Date().timeIntervalSince1970))
    }
    
    func clearAllRecentSearchQueries() {
        searchRepository.clearAllRecentSearchQueries(username: username)
    }
}
