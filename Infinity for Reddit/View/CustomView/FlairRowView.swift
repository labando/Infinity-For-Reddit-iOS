//
// FlairRowView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-14
        
import SwiftUI

struct FlairRowView: View {
    let flairRichtext: [FlairRichtext]
    let flairText: String?
    let emojiSize: CGFloat = 14
    
    var body: some View {
        if flairRichtext.isEmpty {
            if let flairText = flairText, !flairText.isEmpty {
                Text(flairText)
                    .flairRowText()
            } else {
                EmptyView()
            }
        } else {
            HStack(spacing: 2) {
                ForEach(flairRichtext, id: \.self) { part in
                    if part.e == "text", let text = part.t {
                        Text(text)
                            .flairRowText()
                    } else if part.e == "emoji", let url = part.u, let imageURL = URL(string: url) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: emojiSize, height: emojiSize)
                            default:
                                Color.clear
                                    .frame(width: emojiSize, height: emojiSize)
                            }
                        }
                        .baselineOffset(-2) // Align with text
                    } else {
                        // Unknown flair type: safely skip
                        EmptyView()
                    }
                }
            }
        }
    }
}

