//
//  StyledView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-21.
//

import SwiftUI

extension View {
    func themedList() -> some View {
        self.modifier(ListCustomThemeViewModifier())
    }
    
    func listPlainItem() -> some View {
        self.modifier(ListPlainItemThemeViewModifier())
    }
    
    func primaryText() -> some View {
        self.modifier(PrimaryTextViewModifier())
    }
    
    func navigationBarPrimaryText() -> some View {
        self.modifier(NavigationBarPrimaryTextViewModifier())
    }
    
    func themedNavigationBar() -> some View {
        self.modifier(NavigationBarViewModifier())
    }
    
    func addTitleToInlineNavigationBar(_ title: String) -> some View {
        self.modifier(InlineNavigationBarWithTitle(title: title))
    }
    
    func navigationBarButton() -> some View {
        self.modifier(NavigationBarButtonViewModifier())
    }
    
    func navigationBarImage() -> some View {
        self.modifier(NavigationBarImageViewModifier())
    }
}
