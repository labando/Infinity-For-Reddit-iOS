//
// SubredditChooseView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI

struct SubredditChooseView: View {
    var text: String
    var iconUrl: String?
    var iconSize: CGFloat = 24
    var action: () -> Void
    
    var body: some View {
        TouchRipple {
            HStack(spacing: 0) {
                if let icon = iconUrl {
                    CustomWebImage(
                        icon,
                        width: iconSize,
                        height: iconSize,
                        circleClipped: true,
                        handleImageTapGesture: false
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
                
//                Button(action: {}) {
//                    SwiftUI.Image(systemName: isFavorite ? "heart.fill" : "heart")
//                        .foregroundColor(Color(hex: "#EE0264"))
//                }
//                .highPriorityGesture(
//                    TapGesture()
//                        .onEnded {
//                            isFavorite.toggle()
//                            toggleFavorite()
//                        }
//                )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
            .onTapGesture {
                action()
            }
        }
    }
}

