//
//  CustomThemeListingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-20.
//

import SwiftUI
import Swinject
import GRDB

struct CustomThemeListingView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @StateObject private var customThemeListingViewModel: CustomThemeListingViewModel
    
    init() {
        _customThemeListingViewModel = StateObject(
            wrappedValue: CustomThemeListingViewModel(
                customThemeListingRepository: CustomThemeListingRepository()
            )
        )
    }
    
    var body: some View {
        RootView {
            List {
                ForEach(customThemeListingViewModel.customThemes, id: \.self.id) { customTheme in
                    ThemeListItem(themeName: customTheme.name, primaryColor: Color(hex: customTheme.colorPrimary)) {
                        navigationManager.append(CustomThemeSettingsViewNavigation.customizeCustomTheme(customThemeId: customTheme.id))
                    }
                    .listPlainItemNoInsets()
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            customThemeListingViewModel.deleteTheme(customTheme)
                        } label: {
                            Text("Delete")
                                .foregroundStyle(.white)
                        }
                        .tint(.red)
                    }
                }
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Manage Themes")
        .showErrorUsingSnackbar(customThemeListingViewModel.$error)
    }
}
