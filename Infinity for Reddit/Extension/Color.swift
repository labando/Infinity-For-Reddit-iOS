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
    
    init(hex: Int, opacity: Double) {
        if hex > 0xFFFFFF {
            // Has alpha channel
            let red = Double((hex >> 16) & 0xFF) / 255.0
            let green = Double((hex >> 8) & 0xFF) / 255.0
            let blue = Double(hex & 0xFF) / 255.0
            
            self.init(red: red, green: green, blue: blue, opacity: opacity)
        } else {
            let red = Double((hex >> 16) & 0xFF) / 255.0
            let green = Double((hex >> 8) & 0xFF) / 255.0
            let blue = Double(hex & 0xFF) / 255.0
            
            self.init(red: red, green: green, blue: blue, opacity: opacity)
        }
    }
    
    init(hex: String, opacity: Double = 1.0, default defaultColor: Color = .clear) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self = defaultColor
            return
        }
        
        let length = hexSanitized.count
        let r, g, b, a: Double
        
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255
            g = Double((rgb & 0x00FF00) >> 8) / 255
            b = Double(rgb & 0x0000FF) / 255
            a = opacity
        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255
            g = Double((rgb & 0x00FF0000) >> 16) / 255
            b = Double((rgb & 0x0000FF00) >> 8) / 255
            a = Double(rgb & 0x000000FF) / 255
        } else {
            self = defaultColor
            return
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
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
    
    func toHexString(includeAlpha: Bool = true) -> String? {
        let uic = UIColor(self)
        
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil // Failed to get RGB components
        }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        let a = components.count >= 4 ? components[3] : 1.0
        
        let red = Int(round(r * 255))
        let green = Int(round(g * 255))
        let blue = Int(round(b * 255))
        let alpha = Int(round(a * 255))
        
        if includeAlpha || a < 1.0 {
            return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
        } else {
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
    }
    
    static func deriveContrastingColor(hex argb: Int) -> Color {
        let originalColor = Color(hex: argb)
        let originalUIColor = UIColor(originalColor)
        
        // Calculate luminance
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        originalUIColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        
        // Choose blend color based on luminance
        let blendUIColor = luminance < 0.5 ? Color.white : Color.black
        
        return originalColor.mix(with: blendUIColor, by: 0.6)
    }
    
    func mix(with color: Color, by percentage: Double) -> Color {
        let clampedPercentage = min(max(percentage, 0), 1)
        
        let components1 = UIColor(self).cgColor.components!
        let components2 = UIColor(color).cgColor.components!
        
        let red = (1.0 - clampedPercentage) * components1[0] + clampedPercentage * components2[0]
        let green = (1.0 - clampedPercentage) * components1[1] + clampedPercentage * components2[1]
        let blue = (1.0 - clampedPercentage) * components1[2] + clampedPercentage * components2[2]
        let alpha = (1.0 - clampedPercentage) * components1[3] + clampedPercentage * components2[3]
        
        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}
