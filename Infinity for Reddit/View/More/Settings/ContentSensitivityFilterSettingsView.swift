//
// ContentSensitivityFilterSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB

struct ContentSensitivityFilterSettingsView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @AppStorage(ContentSensitivityFilterUserDetailsUtils.sensitiveContentKey, store: .contentSensitivityFilter) private var sensitiveContent: Bool = false
    
    @State var test: Bool = false
    
    var body: some View {
        List {
            TogglePreference(isEnabled: $sensitiveContent, title: "Sensitive Content", icon: "figure.child.and.lock")
                .listPlainItemNoInsets()
            
            TogglePreference(isEnabled: $test, title: "Blur Sensitive Images")
                .listPlainItemNoInsets()
            
            TogglePreference(isEnabled: $test, title: "Don't Blur Senstive Images in Sensitive Subreddits")
                .listPlainItemNoInsets()
            
            TogglePreference(isEnabled: $test, title: "Blur Spoiler Images")
                .listPlainItemNoInsets()
            
            TogglePreference(isEnabled: $test, title: "Disable Sensitive Content Forever")
                .listPlainItemNoInsets()
        }
        .themedList()
        .themedNavigationBar()
    }
}
