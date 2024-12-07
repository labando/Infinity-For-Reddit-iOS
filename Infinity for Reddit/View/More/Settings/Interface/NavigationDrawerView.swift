//
//  NavigationDrawerView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-06.
//

import SwiftUI
import Swinject
import GRDB

struct NavigationDrawerView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @State private var showAvatarOnRight: Bool
    @State private var collapseAccountSection: Bool
    @State private var collapseRedditSection: Bool
    @State private var collapsePostSection: Bool
    @State private var collapsePreferencesSection: Bool
    @State private var collapseFavoriteSubredditsSection: Bool
    @State private var collapseSubscribedSubredditsSection: Bool
    @State private var hideFavoriteSubredditsSection: Bool
    @State private var hideSubscribedSubredditsSection: Bool
    @State private var hideAccountKarma: Bool
    
    private let userDefaults: UserDefaults
    
    private let SHOW_AVATAR_ON_RIGHT = UserDefaultsUtils.SHOW_AVATAR_ON_RIGHT
    private let COLLAPSE_ACCOUNT_SECTION = UserDefaultsUtils.COLLAPSE_ACCOUNT_SECTION
    private let COLLAPSE_REDDIT_SECTION = UserDefaultsUtils.COLLAPSE_REDDIT_SECTION
    private let COLLAPSE_POST_SECTION = UserDefaultsUtils.COLLAPSE_POST_SECTION
    private let COLLAPSE_PREFERENCES_SECTION = UserDefaultsUtils.COLLAPSE_PREFERENCES_SECTION
    private let COLLAPSE_FAVORITE_SUBREDDITS_SECTION = UserDefaultsUtils.COLLAPSE_FAVORITE_SUBREDDITS_SECTION
    private let COLLAPSE_SUBSCRIBED_SUBREDDITS_SECTION = UserDefaultsUtils.COLLAPSE_SUBSCRIBED_SUBREDDITS_SECTION
    private let HIDE_FAVORITE_SUBREDDITS_SECTION = UserDefaultsUtils.HIDE_FAVORITE_SUBREDDITS_SECTION
    private let HIDE_SUBSCRIBED_SUBREDDITS_SECTION = UserDefaultsUtils.HIDE_SUBSCRIBED_SUBREDDITS_SECTION
    private let HIDE_ACCOUNT_KARMA = UserDefaultsUtils.HIDE_ACCOUNT_KARMA_NAV_BAR
    
    init() {
        guard let resolvedUserDefaults = DependencyManager.shared.container.resolve(UserDefaults.self) else {
            fatalError("Failed to resolve UserDefaults")
        }
        self.userDefaults = resolvedUserDefaults
        
        if userDefaults.object(forKey: SHOW_AVATAR_ON_RIGHT) == nil {
            userDefaults.set(false, forKey: SHOW_AVATAR_ON_RIGHT)
        }
        if userDefaults.object(forKey: COLLAPSE_ACCOUNT_SECTION) == nil {
            userDefaults.set(false, forKey: COLLAPSE_ACCOUNT_SECTION)
        }
        if userDefaults.object(forKey: COLLAPSE_REDDIT_SECTION) == nil {
            userDefaults.set(false, forKey: COLLAPSE_REDDIT_SECTION)
        }
        if userDefaults.object(forKey: COLLAPSE_POST_SECTION) == nil {
            userDefaults.set(false, forKey: COLLAPSE_POST_SECTION)
        }
        if userDefaults.object(forKey: COLLAPSE_PREFERENCES_SECTION) == nil {
            userDefaults.set(false, forKey: COLLAPSE_PREFERENCES_SECTION)
        }
        if userDefaults.object(forKey: COLLAPSE_FAVORITE_SUBREDDITS_SECTION) == nil {
            userDefaults.set(false, forKey: COLLAPSE_FAVORITE_SUBREDDITS_SECTION)
        }
        if userDefaults.object(forKey: COLLAPSE_SUBSCRIBED_SUBREDDITS_SECTION) == nil {
            userDefaults.set(false, forKey: COLLAPSE_SUBSCRIBED_SUBREDDITS_SECTION)
        }
        if userDefaults.object(forKey: HIDE_FAVORITE_SUBREDDITS_SECTION) == nil {
            userDefaults.set(false, forKey: HIDE_FAVORITE_SUBREDDITS_SECTION)
        }
        if userDefaults.object(forKey: HIDE_SUBSCRIBED_SUBREDDITS_SECTION) == nil {
            userDefaults.set(false, forKey: HIDE_SUBSCRIBED_SUBREDDITS_SECTION)
        }
        if userDefaults.object(forKey: HIDE_ACCOUNT_KARMA) == nil {
            userDefaults.set(false, forKey: HIDE_ACCOUNT_KARMA)
        }
        
        _showAvatarOnRight = State(initialValue: userDefaults.bool(forKey: SHOW_AVATAR_ON_RIGHT))
        _collapseAccountSection = State(initialValue: userDefaults.bool(forKey: COLLAPSE_ACCOUNT_SECTION))
        _collapseRedditSection = State(initialValue: userDefaults.bool(forKey: COLLAPSE_REDDIT_SECTION))
        _collapsePostSection = State(initialValue: userDefaults.bool(forKey: COLLAPSE_POST_SECTION))
        _collapsePreferencesSection = State(initialValue: userDefaults.bool(forKey: COLLAPSE_PREFERENCES_SECTION))
        _collapseFavoriteSubredditsSection = State(initialValue: userDefaults.bool(forKey: COLLAPSE_FAVORITE_SUBREDDITS_SECTION))
        _collapseSubscribedSubredditsSection = State(initialValue: userDefaults.bool(forKey: COLLAPSE_SUBSCRIBED_SUBREDDITS_SECTION))
        _hideFavoriteSubredditsSection = State(initialValue: userDefaults.bool(forKey: HIDE_FAVORITE_SUBREDDITS_SECTION))
        _hideSubscribedSubredditsSection = State(initialValue: userDefaults.bool(forKey: HIDE_SUBSCRIBED_SUBREDDITS_SECTION))
        _hideAccountKarma = State(initialValue: userDefaults.bool(forKey: HIDE_ACCOUNT_KARMA))
    }
    
    var body: some View {
        List {
            Label("Restart the app to see the changes", systemImage: "info.circle")
                .foregroundColor(.blue)
                .font(.caption)
            
            
            Toggle(isOn: $showAvatarOnRight) {
                Text("Show Avatar on the Right")
            }
            .padding(.leading, 44.5)
            .onChange(of: showAvatarOnRight) { _, newValue in
                userDefaults.set(newValue, forKey: SHOW_AVATAR_ON_RIGHT)
            }
            
            Toggle(isOn: $collapseAccountSection) {
                Text("Collapse Account Section")
            }
            .padding(.leading, 44.5)
            .onChange(of: collapseAccountSection) { _, newValue in
                userDefaults.set(newValue, forKey: COLLAPSE_ACCOUNT_SECTION)
            }
            
            Toggle(isOn: $collapseRedditSection) {
                Text("Collapse Reddit Section")
            }
            .padding(.leading, 44.5)
            .onChange(of: collapseRedditSection) { _, newValue in
                userDefaults.set(newValue, forKey: COLLAPSE_REDDIT_SECTION)
            }
            
            Toggle(isOn: $collapsePostSection) {
                Text("Collapse Post Section")
            }
            .padding(.leading, 44.5)
            .onChange(of: collapsePostSection) { _, newValue in
                userDefaults.set(newValue, forKey: COLLAPSE_POST_SECTION)
            }
            
            Toggle(isOn: $collapsePreferencesSection) {
                Text("Collapse Preferences Section")
            }
            .padding(.leading, 44.5)
            .onChange(of: collapsePreferencesSection) { _, newValue in
                userDefaults.set(newValue, forKey: COLLAPSE_PREFERENCES_SECTION)
            }
            
            Toggle(isOn: $collapseFavoriteSubredditsSection) {
                Text("Collapse Favorite Subreddits Section")
            }
            .padding(.leading, 44.5)
            .onChange(of: collapseFavoriteSubredditsSection) { _, newValue in
                userDefaults.set(newValue, forKey: COLLAPSE_FAVORITE_SUBREDDITS_SECTION)
            }
            
            Toggle(isOn: $collapseSubscribedSubredditsSection) {
                Text("Collapse Subscribed Subreddits Section")
            }
            .padding(.leading, 44.5)
            .onChange(of: collapseSubscribedSubredditsSection) { _, newValue in
                userDefaults.set(newValue, forKey: COLLAPSE_SUBSCRIBED_SUBREDDITS_SECTION)
            }
            
            Toggle(isOn: $hideFavoriteSubredditsSection) {
                Text("Hide Favorite Subreddits Section")
            }
            .padding(.leading, 44.5)
            .onChange(of: hideFavoriteSubredditsSection) { _, newValue in
                userDefaults.set(newValue, forKey: HIDE_FAVORITE_SUBREDDITS_SECTION)
            }
            
            Toggle(isOn: $hideSubscribedSubredditsSection) {
                Text("Hide Subscribed Subreddits Section")
            }
            .padding(.leading, 44.5)
            .onChange(of: hideSubscribedSubredditsSection) { _, newValue in
                userDefaults.set(newValue, forKey: HIDE_SUBSCRIBED_SUBREDDITS_SECTION)
            }
            
            Toggle(isOn: $hideAccountKarma) {
                Text("Hide Account Karma")
            }
            .padding(.leading, 44.5)
            .onChange(of: hideAccountKarma) { _, newValue in
                userDefaults.set(newValue, forKey: HIDE_ACCOUNT_KARMA)
            }
        }
        .navigationTitle("Navigation Drawer")
        
    }
}
