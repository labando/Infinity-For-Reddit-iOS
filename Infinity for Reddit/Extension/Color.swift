//
//  Color.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-01-31.
//

import SwiftUI

extension Color {
    init(hex: Int) {
        if hex > 0xFFFFFF {
            // Has alpha channel
            let alpha = Double((hex >> 24) & 0xFF) / 255.0
            let red = Double((hex >> 16) & 0xFF) / 255.0
            let green = Double((hex >> 8) & 0xFF) / 255.0
            let blue = Double(hex & 0xFF) / 255.0
            
            self.init(red: red, green: green, blue: blue, opacity: alpha)
        } else {
            let alpha = 1.0
            let red = Double((hex >> 16) & 0xFF) / 255.0
            let green = Double((hex >> 8) & 0xFF) / 255.0
            let blue = Double(hex & 0xFF) / 255.0
            
            self.init(red: red, green: green, blue: blue, opacity: alpha)
        }
    }
}

extension Color {
    func toHex() -> Int {
        guard let components = UIColor(self).cgColor.components else { return 0x000000 }
        let alpha = Int(components[3] * 255)
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return (alpha << 24) | (r << 16) | (g << 8) | b
    }
}
