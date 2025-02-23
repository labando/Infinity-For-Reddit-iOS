//
//  TextViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-21.
//

import SwiftUI

struct PrimaryTextViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            //.font()
            .foregroundColor(Color(hex: themeViewModel.currentCustomTheme.primaryTextColor))
    }
}

struct NavigationBarPrimaryTextViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            //.font()
            .foregroundColor(Color(hex: themeViewModel.currentCustomTheme.toolbarPrimaryTextAndIconColor))
            .navigationBarTitleDisplayMode(.inline)
    }
}
