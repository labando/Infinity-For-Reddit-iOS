//
//  NavigationBarViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI

struct NavigationBarViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(hex: themeViewModel.currentCustomTheme.colorPrimary), for: .navigationBar)
    }
}

struct InlineNavigationBarWithTitle: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    var title: String

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .navigationBarPrimaryText()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}
