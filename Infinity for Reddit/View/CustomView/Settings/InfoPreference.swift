//
//  InfoPreference.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-01.
//

import SwiftUI

struct InfoPreference: View {
    var title: String
    var icon: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if let icon {
                    SwiftUI.Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .secondaryIcon()
                    
                    Spacer()
                        .frame(width: 16)
                }
                
                Text(title)
                    .secondaryText()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            
            CustomDivider()
        }
        .limitedWidthListItem()
    }
}
