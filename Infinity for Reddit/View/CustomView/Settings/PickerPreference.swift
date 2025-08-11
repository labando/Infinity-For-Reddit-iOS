//
//  PickerPreference.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-10.
//

import SwiftUI

struct PickerPreference: View {
    @Binding var selectedIndex: Int
    let items: [String]
    let title: String
    var subtitle: String? = nil
    var icon: String? = nil
    
    private var selectedItem: String {
        guard items.indices.contains(selectedIndex) else { return "Select" }
        return items[selectedIndex]
    }
    
    var body: some View {
        Menu {
            ForEach(items.indices, id: \.self) { i in
                Button {
                    selectedIndex = i
                } label: {
                    Text(items[i])
                }
            }
        } label: {
            HStack(spacing: 0) {
                if let icon = icon {
                    SwiftUI.Image(systemName: icon)
                        .primaryIcon()
                        .frame(width: 24, height: 24, alignment: .leading)
                        .padding(0)
                } else {
                    Spacer()
                        .frame(width: 24)
                }
                
                Spacer()
                    .frame(width: 24)
                
                VStack(spacing: 4) {
                    RowText(title)
                        .primaryText()
                    
                    RowText(selectedItem)
                        .secondaryText()
                }
                
                Spacer()
                
                SwiftUI.Image(systemName: "chevron.down")
                    .primaryIcon()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
