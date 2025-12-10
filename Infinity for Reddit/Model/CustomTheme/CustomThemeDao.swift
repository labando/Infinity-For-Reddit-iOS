//
//  CustomThemeDao.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-01-24.
//

import GRDB
import Combine

class CustomThemeDao {
    private let dbPool: DatabasePool

    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
    }

    // MARK: - Insert Operations

    func insert(customTheme: CustomTheme) async throws {
        try await dbPool.write { db in
            try customTheme.insert(db, onConflict: .replace)
        }
    }

    func insertAll(customThemes: [CustomTheme]) async throws {
        try await dbPool.write { db in
            for theme in customThemes {
                try theme.insert(db, onConflict: .replace)
            }
        }
    }

    // MARK: - Query All Themes

    func getAllCustomThemes() async throws -> [CustomTheme] {
        try await dbPool.read { db in
            try CustomTheme.fetchAll(db)
        }
    }

    func getAllCustomThemesPublisher() -> AnyPublisher<[CustomTheme], Error> {
        ValueObservation
            .tracking { db in
                try CustomTheme.fetchAll(db)
            }
            .publisher(in: dbPool)
            .eraseToAnyPublisher()
    }

    // MARK: - Fetch Single Themes by ID

    func getCustomTheme(id: Int) async throws -> CustomTheme? {
        try await dbPool.read { db in
            try CustomTheme
                .filter(Column("id") == id)
                .fetchOne(db)
        }
    }

    func getCustomThemePublisher(id: Int) -> AnyPublisher<CustomTheme?, Error> {
        ValueObservation
            .tracking { db in
                try CustomTheme
                    .filter(Column("id") == id)
                    .fetchOne(db)
            }
            .publisher(in: dbPool)
            .eraseToAnyPublisher()
    }

    func getLightCustomThemePublisher() -> AnyPublisher<CustomTheme?, Error> {
        ValueObservation
            .tracking { db in
                try CustomTheme
                    .filter(Column("isLightTheme") == true)
                    .limit(1)
                    .fetchOne(db)
            }
            .publisher(in: dbPool)
            .eraseToAnyPublisher()
    }

    func getDarkCustomThemePublisher() -> AnyPublisher<CustomTheme?, Error> {
        ValueObservation
            .tracking { db in
                try CustomTheme
                    .filter(Column("isDarkTheme") == true)
                    .limit(1)
                    .fetchOne(db)
            }
            .publisher(in: dbPool)
            .eraseToAnyPublisher()
    }

    func getAmoledCustomThemePublisher() -> AnyPublisher<CustomTheme?, Error> {
        ValueObservation
            .tracking { db in
                try CustomTheme
                    .filter(Column("isAmoledTheme") == true)
                    .limit(1)
                    .fetchOne(db)
            }
            .publisher(in: dbPool)
            .eraseToAnyPublisher()
    }

    // MARK: - Update Operations

    func unsetLightTheme() async throws {
        try await dbPool.write { db in
            try db.execute(sql: "UPDATE custom_themes SET isLightTheme = 0 WHERE isLightTheme = 1")
        }
    }

    func unsetDarkTheme() async throws {
        try await dbPool.write { db in
            try db.execute(sql: "UPDATE custom_themes SET isDarkTheme = 0 WHERE isDarkTheme = 1")
        }
    }

    func unsetAmoledTheme() async throws {
        try await dbPool.write { db in
            try db.execute(sql: "UPDATE custom_themes SET isAmoledTheme = 0 WHERE isAmoledTheme = 1")
        }
    }

    func updateThemeName(id: Int, newName: String) async throws {
        try await dbPool.write { db in
            try db.execute(sql: "UPDATE custom_themes SET name = ? WHERE id = ?", arguments: [newName, id])
        }
    }

    // MARK: - Delete Operations

    func deleteCustomTheme(id: Int) async throws {
        try await dbPool.write { db in
            try db.execute(sql: "DELETE FROM custom_themes WHERE id = ?", arguments: [id])
        }
    }

    func deleteAllCustomThemes() async throws {
        try await dbPool.write { db in
            try db.execute(sql: "DELETE FROM custom_themes")
        }
    }
}
