//
// ThemeSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB

struct CustomThemeSettingsView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    @StateObject private var customThemeSettingsViewModel = CustomThemeSettingsViewModel()
    @StateObject private var customThemeViewModel: CustomThemeViewModel
    
    @AppStorage(CustomThemeUserDefaultsUtils.themeKey, store: .theme) private var theme: Int = CustomThemeUserDefaultsUtils.themeDeviceDefault
    @AppStorage(CustomThemeUserDefaultsUtils.amoledDarkKey, store: .theme) private var amoledDark: Bool = false
    
    init() {
        _customThemeViewModel = StateObject(
            wrappedValue: CustomThemeViewModel()
        )
    }
    
    var body: some View {
        List {
            PickerPreference(
                selectedIndex: $theme,
                items: CustomThemeUserDefaultsUtils.themeOptions,
                title: "Theme",
                icon: "paintbrush.fill"
            )
            .listPlainItemNoInsets()
            
            TogglePreference(
                isEnabled: $amoledDark,
                title: "AMOLED Dark",
                icon: "moon.fill"
            )
            .listPlainItemNoInsets()

            Section(header: Text("Customization").listSectionHeader()) {
                PreferenceEntry(
                    title: "Light Theme",
                    subtitle: customThemeViewModel.currentLightCustomTheme?.name ?? "Indigo",
                    icon: "sun.max"
                ) {
                    navigationManager.path.append(CustomThemeSettingsViewNavigation.customizeCustomTheme(customTheme: customThemeViewModel.currentLightCustomTheme ?? CustomTheme.getIndigo()))
                }
                .listPlainItemNoInsets()
                
                PreferenceEntry(
                    title: "Dark Theme",
                    subtitle: customThemeViewModel.currentDarkCustomTheme?.name ?? "Indigo Dark",
                    icon: "moon"
                ) {
                    navigationManager.path.append(CustomThemeSettingsViewNavigation.customizeCustomTheme(customTheme: customThemeViewModel.currentLightCustomTheme ?? CustomTheme.getIndigo()))
                }
                .listPlainItemNoInsets()
                
                PreferenceEntry(
                    title: "Amoled Theme",
                    subtitle: customThemeViewModel.currentAmoledCustomTheme?.name ?? "Indigo Amoled",
                    icon: "moon"
                ) {
                    navigationManager.path.append(CustomThemeSettingsViewNavigation.customizeCustomTheme(customTheme: customThemeViewModel.currentLightCustomTheme ?? CustomTheme.getIndigo()))
                }
                .listPlainItemNoInsets()
                
                PreferenceEntry(
                    title: "Manage Themes",
                    icon: "pencil"
                ) {
                    navigationManager.path.append(CustomThemeSettingsViewNavigation.customThemeListing)
                }
                .listPlainItemNoInsets()
            }
            .listPlainItem()
        }
        .themedList()
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Theme")
    }
}
