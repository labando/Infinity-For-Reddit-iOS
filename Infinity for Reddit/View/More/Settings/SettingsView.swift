//
// SettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB

struct SettingsView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    var body: some View {
        List {
            NavigationLink(destination: NotificationSettingsView()) {
                Text("Notification")
            }
            .listPlainItem()
            NavigationLink(destination: InterfaceSettingsView()) {
                Text("Interface")
            }
            .listPlainItem()
            NavigationLink(destination: CustomThemeSettingsView()) {
                Text("Theme")
            }
            .listPlainItem()
            NavigationLink(destination: GestureButtonsSettingsView()) {
                Text("Gesture & Buttons")
            }
            .listPlainItem()
            NavigationLink(destination: VideoSettingsView()) {
                Text("Video")
            }
            .listPlainItem()
            NavigationLink(destination: LazyModeIntervalSettingsView()) {
                Text("Lazy Mode Interval")
            }
            .listPlainItem()
            NavigationLink(destination: DownloadLocationSettingsView()) {
                Text("Download Location")
            }
            .listPlainItem()
            NavigationLink(destination: SecuritySettingsView()) {
                Text("Security")
            }
            .listPlainItem()
            NavigationLink(destination: ContentSensitivityFilterSettingsView()) {
                Text("Content Sensitivity Filter")
            }
            .listPlainItem()
            NavigationLink(destination: PostHistorySettingsView()) {
                Text("Post History")
            }
            .listPlainItem()
            NavigationLink(destination: PostFilterSettingsView()) {
                Text("Post Filter")
            }
            .listPlainItem()
            NavigationLink(destination: CommentFilterSettingsView()) {
                Text("Comment Filter")
            }
            .listPlainItem()
            NavigationLink(destination: MiscellaneousSettingsView()) {
                Text("Miscellaneous")
            }
            .listPlainItem()
            NavigationLink(destination: AdvancedSettingsView()) {
                Text("Advanced")
            }
            .listPlainItem()
            NavigationLink(destination: ManageSubscriptionSettingsView()) {
                Text("Manage Subscription")
            }
            .listPlainItem()
            NavigationLink(destination: AboutSettingsView()) {
                Text("About")
            }
            .listPlainItem()
            NavigationLink(destination: PrivacyPolicySettingsView()) {
                Text("Privacy Policy")
            }
            .listPlainItem()
            NavigationLink(destination: RedditUserAgreementSettingsView()) {
                Text("Reddit User Agreement")
            }
            .listPlainItem()
        }
        .applyCustomThemeToList()
        .navigationTitle("Settings")
    }
}
