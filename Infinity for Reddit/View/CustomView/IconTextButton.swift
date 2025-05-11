//
//  IconTextButton.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-11.
//

import SwiftUI

struct IconTextButton: View {
    var iconUrl: String
    var isWebImage: Bool = false
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isWebImage {
                    CustomWebImage(
                        iconUrl,
                        width: 24,
                        height: 24,
                        circleClipped: true,
                        handleImageTapGesture: false,
                        fallbackView: {
                            SwiftUI.Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .primaryIcon()
                        }
                    )
                } else {
                    SwiftUI.Image(systemName: iconUrl)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .primaryIcon()
                }
                
                Spacer()
                    .frame(width: 32)
                
                Text(text)
                    .primaryText()
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
