//
//  CommentIndentationView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-03.
//

import SwiftUI

struct CommentIndentationView: View {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    @AppStorage(InterfaceCommentUserDefaultsUtils.showOnlyOneCommentLevelIndicatorKey, store: .interfaceComment)
    private var showOnlyOneCommentLevelIndicator: Bool = false
    
    let depth: Int

    // TODO optimize this please
    var depthColors: [Color] {
        [
            Color(hex: themeViewModel.currentCustomTheme.commentVerticalBarColor1),
            Color(hex: themeViewModel.currentCustomTheme.commentVerticalBarColor2),
            Color(hex: themeViewModel.currentCustomTheme.commentVerticalBarColor3),
            Color(hex: themeViewModel.currentCustomTheme.commentVerticalBarColor4),
            Color(hex: themeViewModel.currentCustomTheme.commentVerticalBarColor5),
            Color(hex: themeViewModel.currentCustomTheme.commentVerticalBarColor6),
            Color(hex: themeViewModel.currentCustomTheme.commentVerticalBarColor7)
        ]
    }
    
    var body: some View {
        if depth > 0 {
            if showOnlyOneCommentLevelIndicator {
                Rectangle()
                    .fill(depthColors[(depth - 1) % depthColors.count])
                    .frame(width: 2)
                    .padding(.leading, CGFloat(10 * depth))
            } else {
                HStack(spacing: 8) {
                    ForEach(0..<depth, id:\.self) { depth in
                        Rectangle()
                            .fill(depthColors[depth % depthColors.count])
                            .frame(width: 2)
                    }
                }
                .padding(.leading, 10)
            }
        }
    }
}
