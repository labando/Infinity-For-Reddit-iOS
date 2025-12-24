//
//  ThemeListItem.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-12-10.
//

import SwiftUI

struct ThemeListItem: View {
    let themeName: String
    let primaryColor: Color
    let onTap: () -> Void
    
    var body: some View {
        TouchRipple(action: onTap) {
            HStack(spacing: 24) {
                Circle()
                    .fill(primaryColor)
                    .frame(width: 24, height: 24)
                
                RowText(themeName)
                    .primaryText()
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .limitedWidthListItem()
    }
}
