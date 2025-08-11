//
//  CustomTextField.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-01.
//

import SwiftUI

struct CustomTextField: View {
    @EnvironmentObject var customThemeViewModel: CustomThemeViewModel
    
    @Binding var text: String
    var placeholder: String
    private let singleLine: Bool
    private let keyboardType: UIKeyboardType
    private let showBorder: Bool
    
    init(_ placeholder: String = "",
         text: Binding<String>,
         singleLine: Bool = false,
         keyboardType: UIKeyboardType = .default,
         showBorder: Bool = true
    ) {
        self.placeholder = placeholder
        _text = text
        self.singleLine = singleLine
        self.keyboardType = keyboardType
        self.showBorder = showBorder
    }
    
    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .foregroundStyle(Color(hex: customThemeViewModel.currentCustomTheme.secondaryTextColor)),
            axis: singleLine ? .horizontal : .vertical
        )
        .primaryText()
        .keyboardType(keyboardType)
        .tint(Color(hex: customThemeViewModel.currentCustomTheme.colorPrimary))
        .applyIf(showBorder) {
            // TODO different border color for different focus state
            $0.padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: customThemeViewModel.currentCustomTheme.primaryTextColor), lineWidth: 1)
                )
        }
    }
}
