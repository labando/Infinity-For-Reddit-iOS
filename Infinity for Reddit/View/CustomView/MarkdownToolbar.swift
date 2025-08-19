//
//  MarkdownToolbar.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-18.
//

import SwiftUI

struct MarkdownToolbar: View {
    var onBold: () -> Void
    var onItalic: () -> Void
    var onLink: () -> Void
    var onStrikeThrough: () -> Void
    var onSuperscript: () -> Void
    var onHeader: () -> Void
    var onOrderedList: () -> Void
    var onUnorderedList: () -> Void
    var onSpoiler: () -> Void
    var onQuote: () -> Void
    var onCodeBlock: () -> Void
    var onUploadImage: () -> Void
    var onGiphyGif: () -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                TouchRipple(backgroundShape: Circle(), action: onBold) {
                    SwiftUI.Image(systemName: "bold")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onItalic) {
                    SwiftUI.Image(systemName: "italic")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onLink) {
                    SwiftUI.Image(systemName: "link")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onStrikeThrough) {
                    SwiftUI.Image(systemName: "strikethrough")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onSuperscript) {
                    SwiftUI.Image(systemName: "textformat.superscript")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onHeader) {
                    SwiftUI.Image(systemName: "h.circle")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onOrderedList) {
                    SwiftUI.Image(systemName: "list.number")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onUnorderedList) {
                    SwiftUI.Image(systemName: "list.bullet")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onSpoiler) {
                    SwiftUI.Image(systemName: "exclamationmark.triangle.fill")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onQuote) {
                    SwiftUI.Image(systemName: "quote.opening")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onCodeBlock) {
                    SwiftUI.Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onUploadImage) {
                    SwiftUI.Image(systemName: "photo")
                        .primaryIcon()
                        .padding(16)
                }
                
                TouchRipple(backgroundShape: Circle(), action: onGiphyGif) {
                    SwiftUI.Image("gif")
                        .primaryIcon()
                        .padding(16)
                }
            }
        }
    }
}
