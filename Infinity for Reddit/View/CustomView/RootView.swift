//
//  RootView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-29.
//

import SwiftUI

struct RootView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        content()
            .rootViewBackground()
    }
}
