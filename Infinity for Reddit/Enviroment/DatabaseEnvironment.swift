//
//  DatabaseEnvironment.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-11-30.
//

import SwiftUI
import GRDB

struct RedditGRDBDatabaseKey: EnvironmentKey {
    static let defaultValue: DatabasePool = RedditGRDBDatabase.shared.dbPool
}

extension EnvironmentValues {
    var redditGRDBDatabasePool: DatabasePool {
        get { self[RedditGRDBDatabaseKey.self] } set { self[RedditGRDBDatabaseKey.self] = newValue }
    }
}
