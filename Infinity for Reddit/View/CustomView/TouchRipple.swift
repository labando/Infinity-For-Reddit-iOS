//
//  TouchRipple.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-17.
//

import SwiftUI

struct TouchRipple<Content: View, BackgroundShape: Shape>: View {
    let backgroundShape: BackgroundShape
    var action: (() -> Void)? = nil
    let content: () -> Content

    @State private var isPressed = false
    @State private var dragStartLocation: CGPoint? = nil
    
    let maxTapMovement: CGFloat = 10

    var body: some View {
        content()
            .overlay(
                backgroundShape
                    .fill(Color.black.opacity(isPressed ? 0.05 : 0))
                    .animation(.easeInOut(duration: 0.15), value: isPressed)
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if dragStartLocation == nil {
                            dragStartLocation = value.startLocation
                        }
                        
                        guard let start = dragStartLocation else { return }
                        let distance = hypot(value.location.x - start.x, value.location.y - start.y)
                        
                        if distance <= maxTapMovement {
                            if !isPressed {
                                isPressed = true
                            }
                        } else {
                            if isPressed {
                                isPressed = false
                            }
                        }
                    }
                    .onEnded { value in
                        defer {
                            dragStartLocation = nil
                            isPressed = false
                        }
                        
                        guard let start = dragStartLocation else { return }
                        let dragDistance = hypot(value.location.x - start.x, value.location.y - start.y)
                        
                        if dragDistance <= maxTapMovement {
                            action?()
                        }
                    }
            )
    }
}
