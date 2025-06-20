//
//  TapActionViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-20.
//

import SwiftUI

struct TapActionModifier: ViewModifier {
    let url: URL?
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                if let url = url {
                    ShareLink(item: url)
                }
            }
    }
}
