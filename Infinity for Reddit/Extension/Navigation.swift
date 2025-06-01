//
//  NavigationDestination.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-29.
//

import SwiftUI

extension View {
    func setUpHomeTabViewChildNavigationBar() -> some View {
        self.modifier(NavigationStackItemViewModifier())
    }
}
