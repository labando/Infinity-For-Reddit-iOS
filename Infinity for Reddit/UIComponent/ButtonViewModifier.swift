//
//  ButtonViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI

struct NavigationBarButtonViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            //.font()
            .foregroundColor(Color(hex: themeViewModel.currentCustomTheme.toolbarPrimaryTextAndIconColor))
    }
}
