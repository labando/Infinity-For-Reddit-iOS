//
//  SegmentedPicker.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-04-05.
//

import SwiftUI

struct SegmentedPicker: View {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    @Namespace var pickerAnimation
    
    var selectedValue: Binding<Int>
    let values: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(values.indices, id: \.self) { index in
                let isSelected = index == selectedValue.wrappedValue
                
                Button(action: {
                    withAnimation(.spring(duration: 0.25)) {
                        selectedValue.wrappedValue = index
                    }
                }) {
                    Text(values[index])
                        .customFont(fontSize: .f13)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundStyle(Color(hex: isSelected ? themeViewModel.currentCustomTheme.pickerSelectedItemTextColor : themeViewModel.currentCustomTheme.pickerItemTextColor))
                        .background {
                            if isSelected {
                                Capsule()
                                    .foregroundColor(Color(hex: themeViewModel.currentCustomTheme.pickerSelectedItemBackgroundColor))
                                    .matchedGeometryEffect(id: "background", in: pickerAnimation)
                            }
                        }
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
        }
        .padding(4)
    }
}
