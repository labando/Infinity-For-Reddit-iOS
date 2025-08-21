//
//  SimpleWebImageTouchItemRow.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-18.
//

import SwiftUI

struct SimpleWebImageTouchItemRow: View {
    var text: String
    var iconUrl: String?
    var iconSize: CGFloat = 24
    var action: (() -> Void)?
    
    var body: some View {
        TouchRipple(action: action) {
            HStack(spacing: 0) {
                if let icon = iconUrl {
                    CustomWebImage(
                        icon,
                        width: iconSize,
                        height: iconSize,
                        circleClipped: true,
                        handleImageTapGesture: false,
                        fallbackView: {
                            SwiftUI.Image(systemName: "person.crop.circle")
                                .primaryIcon()
                        }
                    )
                } else {
                    Spacer()
                        .frame(width: iconSize)
                }
                
                Spacer()
                    .frame(width: 24)
                
                Text(text)
                    .primaryText()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
    }
}
