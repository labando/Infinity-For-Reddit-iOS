//
//  GenericViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-14.
//

import SwiftUI

struct NoPreviewPostTypeIndicatorBackgroundViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, minHeight: 96)
            .padding(.horizontal, 16)
            .background(Color(hex: themeViewModel.currentCustomTheme.noPreviewPostTypeBackgroundColor))
    }
}

struct NoPreviewPostTypeIndicatorViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(hex: themeViewModel.currentCustomTheme.noPreviewPostTypeIconTint))
    }
}
