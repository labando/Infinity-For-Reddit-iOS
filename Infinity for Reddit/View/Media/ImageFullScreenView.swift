//
//  ImageFullScreenView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-03.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageFullScreenView: View {
    let url: URL?
    let onDismiss: () -> Void
    
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.opacity(opacityForBackground())
                .ignoresSafeArea()
            
            WebImage(url: url)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width)
                .offset(dragOffset)
                .transition(.identity)
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    // Only allow vertical drag to trigger dismiss
                    if abs(value.translation.height) > abs(value.translation.width) {
                        state = value.translation
                    }
                }
                .onEnded { value in
                    if abs(value.translation.height) > 100 {
                        onDismiss()
                    }
                }
        )
        .edgesIgnoringSafeArea(.all)
        .ignoresSafeArea()
        .transition(.opacity)
    }
    
    private func opacityForBackground() -> Double {
        let maxOffset: CGFloat = 300
        let offset = min(abs(dragOffset.height), maxOffset)
        return Double(1 - (offset / maxOffset))
    }
}
