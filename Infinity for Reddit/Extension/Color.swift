//
//  Color.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-01-31.
//

import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Color {
    func toHex() -> Int {
        guard let components = UIColor(self).cgColor.components else { return 0x000000 }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return (r << 16) | (g << 8) | b
    }
}
