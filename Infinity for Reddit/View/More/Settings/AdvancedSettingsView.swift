//
// AdvancedSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI

struct AdvancedSettingsView: View {
    @StateObject private var advancedSettingsViewModel = AdvancedSettingsViewModel()
    @State private var pendingAction: AdvancedAction?
    @State private var isPerformingAction = false
    
    var body: some View {
        RootView {
            List {
                CustomListSection("Database") {
                    PreferenceEntry(title: "Delete All Subreddits in Database", icon: "tray.full") {
                        showConfirmation(for: .deleteSubreddits)
                    }
                    .listPlainItemNoInsets()
                    .disabled(isPerformingAction)
                    
                    PreferenceEntry(title: "Delete All Users in Database", icon: "person.3") {
                        showConfirmation(for: .deleteUsers)
                    }
                    .listPlainItemNoInsets()
                    .disabled(isPerformingAction)
                    
                    PreferenceEntry(title: "Delete All Sort Types in Database", icon: "arrow.up.arrow.down") {
                        showConfirmation(for: .deleteSortTypes)
                    }
                    .listPlainItemNoInsets()
                    .disabled(isPerformingAction)
                    
                    PreferenceEntry(title: "Delete All Post Layouts in Database", icon: "rectangle.3.offgrid") {
                        showConfirmation(for: .deletePostLayouts)
                    }
                    .listPlainItemNoInsets()
                    .disabled(isPerformingAction)
                    
                    PreferenceEntry(title: "Delete All Themes in Database", icon: "paintpalette") {
                        showConfirmation(for: .deleteThemes)
                    }
                    .listPlainItemNoInsets()
                    .disabled(isPerformingAction)
                    
                    PreferenceEntry(title: "Delete All Front Page Scrolled Positions in Database", icon: "arrow.uturn.backward") {
                        showConfirmation(for: .deleteFrontPagePositions)
                    }
                    .listPlainItemNoInsets()
                    .disabled(isPerformingAction)
                    
                    PreferenceEntry(title: "Delete All Read Posts in Database", icon: "book") {
                        showConfirmation(for: .deleteReadPosts)
                    }
                    .listPlainItemNoInsets()
                    .disabled(isPerformingAction)
                }
                
                CustomListSection("Preferences") {
                    PreferenceEntry(title: "Reset All Settings", icon: "arrow.counterclockwise") {
                        showConfirmation(for: .resetAllSettings)
                    }
                    .listPlainItemNoInsets()
                    .disabled(isPerformingAction)
                }
                
                CustomListSection("Backup & Restore") {
                    PreferenceEntry(title: "Backup Settings", icon: "arrow.up.doc") { }
                        .listPlainItemNoInsets()
                        .disabled(isPerformingAction)
                    
                    PreferenceEntry(title: "Restore Settings", icon: "arrow.down.doc") { }
                        .listPlainItemNoInsets()
                        .disabled(isPerformingAction)
                }
                
                CustomListSection("Diagnostics") {
                    PreferenceEntry(title: "Crash Reports", icon: "exclamationmark.triangle") { }
                        .listPlainItemNoInsets()
                        .disabled(isPerformingAction)
                }
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Advanced")
        .overlay(alignment: .center) {
            if isPerformingAction {
                ProgressView("Working…")
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding()
            }
        }
        .overlay(
            CustomAlert(
                title: "Are you sure?",
                buttonStyle: .warning,
                isPresented: Binding(
                    get: { pendingAction != nil },
                    set: { newValue in
                        if !newValue {
                            pendingAction = nil
                        }
                    }
                )
            ) {
                EmptyView()
            } onConfirm: {
                if let action = pendingAction {
                    pendingAction = nil
                    handleAdvancedAction(action)
                }
            }
        )
    }
    
    private func showConfirmation(for action: AdvancedAction) {
        guard !isPerformingAction else { return }
        withAnimation(.linear(duration: 0.2)) {
            pendingAction = action
        }
    }
    
    private func handleAdvancedAction(_ action: AdvancedAction) {
        switch action {
        case .deleteSubreddits:
            runAction {
                try await advancedSettingsViewModel.deleteAllSubreddits()
            }
        case .deleteUsers:
            runAction {
                try await advancedSettingsViewModel.deleteAllUsers()
            }
        case .deleteSortTypes:
            runAction {
                await advancedSettingsViewModel.deleteAllSortTypes()
            }
        case .deletePostLayouts:
            runAction {
                await advancedSettingsViewModel.deleteAllPostLayouts()
            }
        case .deleteThemes:
            runAction {
                try await advancedSettingsViewModel.deleteAllThemes()
            }
        case .deleteFrontPagePositions:
            runAction {
                await advancedSettingsViewModel.deleteFrontPagePositions()
            }
        case .deleteReadPosts:
            runAction {
                try await advancedSettingsViewModel.deleteReadPosts()
            }
        case .resetAllSettings:
            runAction {
                await advancedSettingsViewModel.resetAllSettings()
            }
        }
    }
    
    private func runAction(_ action: @escaping () async throws -> Void) {
        isPerformingAction = true
        Task {
            do {
                try await action()
            } catch {
                print("Advanced settings action failed:", error)
            }
            isPerformingAction = false
        }
    }
}

private enum AdvancedAction {
    case deleteSubreddits
    case deleteUsers
    case deleteSortTypes
    case deletePostLayouts
    case deleteThemes
    case deleteFrontPagePositions
    case deleteReadPosts
    case resetAllSettings
}
