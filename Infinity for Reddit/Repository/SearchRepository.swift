//
//  SearchRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-18.
//

import Foundation

class SearchRepository: SearchRepositoryProtocol {
    private let recentSearchQueryDao: RecentSearchQueryDao
    private let operationQueue: OperationQueue
    
    init(recentSearchQueryDao: RecentSearchQueryDao, operationQueue: OperationQueue) {
        self.recentSearchQueryDao = recentSearchQueryDao
        self.operationQueue = operationQueue
    }
    
    func saveSearchQuery(username: String, query: String, searchInSubredditOrUserName: String?, multiRedditPath: String?, searchInThingType: Int, time: Int64) {
        operationQueue.addOperation {
            do {
                try self.recentSearchQueryDao.insert(recentSearchQuery:
                                                    RecentSearchQuery(username: username,
                                                                      searchQuery: query,
                                                                      searchInSubredditOrUserName: searchInSubredditOrUserName,
                                                                      multiRedditPath: multiRedditPath,
                                                                      searchInThingType: searchInThingType,
                                                                      time: time)
                )
            } catch {
                // No need to handle error
                print(error)
            }
        }
    }
    
    func clearAllRecentSearchQueries(username: String) {
        operationQueue.addOperation {
            do {
                try self.recentSearchQueryDao.deleteAllRecentSearchQueries(username: username)
            } catch {
                // No need to handle error
                print(error)
            }
        }
    }
}
