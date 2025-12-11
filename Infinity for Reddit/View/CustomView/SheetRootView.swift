//
//  SheetRootView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-12-09.
//

import SwiftUI

struct SheetRootView<Content: View>: View {
    @EnvironmentObject private var customThemeViewModel: CustomThemeViewModel
    
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        content()
            .presentationBackground(Color(hex: customThemeViewModel.currentCustomTheme.backgroundColor))
    }
}
