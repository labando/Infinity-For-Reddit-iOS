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
    
    init(_ placeholder: String = "", text: Binding<String>, singleLine: Bool = false) {
        self.placeholder = placeholder
        _text = text
        self.singleLine = singleLine
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
        .tint(Color(hex: customThemeViewModel.currentCustomTheme.colorPrimary))
    }
}
