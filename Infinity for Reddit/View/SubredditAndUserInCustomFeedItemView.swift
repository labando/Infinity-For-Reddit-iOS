//
//  SubredditAndUserInCustomFeedItemView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import SwiftUI

struct SubredditAndUserInCustomFeedItemView: View {
    var text: String
    var iconUrlString: String?
    var iconSize: CGFloat = 24
    var onDelete: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            if let icon = iconUrlString {
                CustomWebImage(
                    icon,
                    width: iconSize,
                    height: iconSize,
                    circleClipped: true,
                    handleImageTapGesture: false,
                    fallbackView: {
                        InitialLetterAvatarImageFallbackView(name: text, size: iconSize)
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
            
            if onDelete != nil {
                Button(action: {
                    onDelete?()
                }) {
                    SwiftUI.Image(systemName: "trash")
                        .primaryIcon()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
}
