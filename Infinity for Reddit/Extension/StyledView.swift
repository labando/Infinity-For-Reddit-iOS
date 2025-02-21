//
//  StyledView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-21.
//

import SwiftUI

extension View {
    func applyCustomThemeToList() -> some View {
        self.modifier(ListCustomThemeViewModifier())
    }
    
    func listPlainItem() -> some View {
        self.modifier(ListPlainItemThemeViewModifier())
    }
}
