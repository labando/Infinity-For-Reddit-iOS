//
//  InitialLetterAvatarImageFallbackView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-19.
//

import SwiftUI

struct InitialLetterAvatarImageFallbackView: View {
    let name: String?
    var size: CGFloat
    
    private var initial: String {
        if let name = name {
            return name.isEmpty ? "?" : String(name.first ?? "?").uppercased()
        }
        
        return "?"
    }
    
    var body: some View {
        Text(initial)
            .font(.system(size: size * 0.6, weight: .bold, design: .monospaced))
            .frame(width: size, height: size)
            .foregroundColor(.white)
            .background(Color.gray)
            .clipShape(Circle())
            .offset(y: 1)
    }
}
