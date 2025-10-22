//
//  TextFieldViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-22.
//

import SwiftUI

struct URLTextFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
