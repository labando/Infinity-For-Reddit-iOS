//
//  ListPlainItemThemeViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-21.
//

import SwiftUI

struct ListPlainItemThemeViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            .background(Color.clear)
            .listRowSeparator(.hidden)
    }
}
