//
//  CustomThemeListingRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-12-10.
//

import GRDB
import Foundation

class CustomThemeListingRepository: CustomThemeListingRepositoryProtocol {
    private let customThemeDao: CustomThemeDao
    
    enum CustomThemeListingRepositoryError: LocalizedError {
        case invalidId
        
        var errorDescription: String? {
            switch self {
            case .invalidId:
                return "Invalid theme id"
            }
        }
    }
    
    init() {
        guard let resolvedDatabasePool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Could not resolve DatabasePool in CustomThemeListingRepository")
        }
        
        self.customThemeDao = CustomThemeDao(dbPool: resolvedDatabasePool)
    }
    
    func deleteTheme(_ customTheme: CustomTheme) async throws {
        guard let id = customTheme.id else {
            throw CustomThemeListingRepositoryError.invalidId
        }
        
        try await customThemeDao.deleteCustomTheme(id: id)
    }
}
