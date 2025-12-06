//
// AnonymousMultiredditSubredditDao.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import GRDB

struct AnonymousCustomFeedSubredditDao {
    private let dbPool: DatabasePool
    
    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
    }
    
    func insert(anonymousMultiredditSubreddit: AnonymousCustomFeedSubreddit) async throws {
        try await dbPool.write { db in
            try anonymousMultiredditSubreddit.insert(db, onConflict: .replace)
        }
    }
    
    func insertAll(anonymousMultiredditSubreddits: [AnonymousCustomFeedSubreddit]) async throws {
        try await dbPool.write { db in
            for subreddit in anonymousMultiredditSubreddits {
                try subreddit.insert(db, onConflict: .replace)
            }
        }
    }
    
    func getAllAnonymousMultiRedditSubreddits(path: String) async throws -> [AnonymousCustomFeedSubreddit] {
        try await dbPool.read { db in
            try AnonymousCustomFeedSubreddit.fetchAll(
                db, sql: "SELECT * FROM anonymous_custom_feed_subreddits WHERE path = ? ORDER BY subreddit_name COLLATE NOCASE ASC", arguments: [path]
            )
        }
    }
    
    func getAllSubreddits() async throws -> [AnonymousCustomFeedSubreddit] {
        try await dbPool.read { db in
            try AnonymousCustomFeedSubreddit.fetchAll(db)
        }
    }
}
