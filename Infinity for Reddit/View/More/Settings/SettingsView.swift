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
    @State private var selectedItem: Int? = nil
    
    var body: some View {
        List {
            NavigationLink(destination: NotificationSettingsView()) {
                Text("Notification")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: InterfaceSettingsView()) {
                Text("Interface")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: CustomThemeSettingsView()) {
                Text("Theme")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: GestureButtonsSettingsView()) {
                Text("Gesture & Buttons")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: VideoSettingsView()) {
                Text("Video")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: LazyModeIntervalSettingsView()) {
                Text("Lazy Mode Interval")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: DownloadLocationSettingsView()) {
                Text("Download Location")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: SecuritySettingsView()) {
                Text("Security")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: ContentSensitivityFilterSettingsView()) {
                Text("Content Sensitivity Filter")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: PostHistorySettingsView()) {
                Text("Post History")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: PostFilterSettingsView()) {
                Text("Post Filter")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: CommentFilterSettingsView()) {
                Text("Comment Filter")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: MiscellaneousSettingsView()) {
                Text("Miscellaneous")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: AdvancedSettingsView()) {
                Text("Advanced")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: ManageSubscriptionSettingsView()) {
                Text("Manage Subscription")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: AboutSettingsView()) {
                Text("About")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: PrivacyPolicySettingsView()) {
                Text("Privacy Policy")
                    .primaryText()
            }
            .listPlainItem()
            
            NavigationLink(destination: RedditUserAgreementSettingsView()) {
                Text("Reddit User Agreement")
                    .primaryText()
            }
            .listPlainItem()
        }
        .themedList()
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Settings")
    }
}
