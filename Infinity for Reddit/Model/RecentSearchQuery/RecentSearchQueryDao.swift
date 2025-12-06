//
// RecentSearchQueryDao.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-03
//

import GRDB
import Combine

struct RecentSearchQueryDao {
    private let dbPool: DatabasePool
    
    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
    }
    
    func insert(recentSearchQuery: RecentSearchQuery) async throws {
        try await dbPool.write { db in
            try recentSearchQuery.insert(db, onConflict: .replace)
        }
    }
    
    func insertAll(recentSearchQueries: [RecentSearchQuery]) async throws {
        try await dbPool.write { db in
            for data in recentSearchQueries {
                try data.insert(db, onConflict: .replace)
            }
        }
    }
    
    func getAllRecentSearchQueriesLiveData(username: String) -> AnyPublisher<[RecentSearchQuery], Error> {
        ValueObservation.tracking { db in
            try RecentSearchQuery.fetchAll(db, sql: """
                SELECT *
                FROM recent_search_queries
                WHERE username = ?
                ORDER BY time DESC
                """, arguments: [username])
        }
        .publisher(in: dbPool)
        .eraseToAnyPublisher()
    }
    
    func getAllRecentSearchQueries(username: String) async throws -> [RecentSearchQuery] {
        try await dbPool.read { db in
            try RecentSearchQuery.fetchAll(db, sql: """
                SELECT *
                FROM recent_search_queries
                WHERE username = ?
                ORDER BY time DESC
                """, arguments: [username])
        }
    }
    
    func deleteAllRecentSearchQueries(username: String) async throws {
        try await dbPool.write{ db in
            try db.execute(sql: """
                DELETE FROM recent_search_queries 
                WHERE username = ?
                """, arguments: [username]
            )
        }
    }
    
    func deleteRecentSearchQuery(recentSearchQuery: RecentSearchQuery) async throws {
        try await dbPool.write { db in
            try recentSearchQuery.delete(db)
        }
    }
}
