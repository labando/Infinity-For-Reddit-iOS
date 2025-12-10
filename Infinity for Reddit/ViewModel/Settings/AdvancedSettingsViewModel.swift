//
//  AdvancedSettingsViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-04.
//

import Foundation
import Swinject
import GRDB

@MainActor
final class AdvancedSettingsViewModel: ObservableObject {
    private let container: Container
    private let dbPool: DatabasePool
    private let subredditDao: SubredditDao
    private let userDao: UserDao
    private let postHistoryDao: PostHistoryDao
    private let customThemeDao: CustomThemeDao
    
    init(container: Container = DependencyManager.shared.container) {
        self.container = container
        guard let resolvedPool = container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.dbPool = resolvedPool
        self.subredditDao = SubredditDao(dbPool: resolvedPool)
        self.userDao = UserDao(dbPool: resolvedPool)
        self.postHistoryDao = PostHistoryDao(dbPool: resolvedPool)
        self.customThemeDao = CustomThemeDao(dbPool: resolvedPool)
    }
    
    func deleteAllSubreddits() async throws {
        try await subredditDao.deleteAllSubreddits()
    }
    
    func deleteAllUsers() async throws {
        try await userDao.deleteAllUsers()
    }
    
    func deleteAllSortTypes() async {
        guard let sortTypeDefaults = UserDefaults.sortType else {
            return
        }
        
        SortTypeUserDetailsUtils.getAllKeys.forEach {
            sortTypeDefaults.removeObject(forKey: $0)
        }
        
        SortTypeSettingsUserDefaultsUtils.getAllKeys.forEach {
            UserDefaults.sortTypeSettings.removeObject(forKey: $0)
        }
    }
    
    func deleteAllPostLayouts() async {
        if let postLayoutDefaults = UserDefaults.postLayout {
            PostLayoutUserDefaultsUtils.getAllKeys().forEach {
                postLayoutDefaults.removeObject(forKey: $0)
            }
        }
        
        UserDefaults.interfacePost.removeObject(forKey: InterfacePostUserDefaultsUtils.defaultPostLayoutKey)
        UserDefaults.interfacePost.removeObject(forKey: InterfacePostUserDefaultsUtils.defaultLinkPostLayoutKey)
    }
    
    func deleteAllThemes() async throws {
        try await customThemeDao.deleteAllCustomThemes()
    }
    
    func deleteFrontPagePositions() async {
        MiscellaneousUserDefaultsUtils.frontPagePositionKeys().forEach {
            UserDefaults.miscellaneous.removeObject(forKey: $0)
        }
    }
    
    func deleteReadPosts() async throws {
        try await postHistoryDao.deleteAllReadPosts()
    }
    
    func resetAllSettings() async {
        let disableSensitiveContentForever = ContentSensitivityFilterUserDetailsUtils.disableSensitiveContentForever
        
        for defaults in UserDefaultsResetTargets.stores {
            defaults.dictionaryRepresentation().keys.forEach {
                defaults.removeObject(forKey: $0)
            }
        }
        
        if disableSensitiveContentForever {
            UserDefaults.contentSensitivityFilter.set(
                true,
                forKey: ContentSensitivityFilterUserDetailsUtils.disableSensitiveContentForeverKey)
        }
    }
    
    func backupSettings() async throws {

    }
    
    func restoreSettings() async throws {

    }
    
    func openCrashReports() {

    }
}
