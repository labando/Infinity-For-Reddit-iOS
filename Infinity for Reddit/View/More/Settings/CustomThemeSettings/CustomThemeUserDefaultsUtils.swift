//
//  CustomThemeUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-03.
//

import Foundation

class CustomThemeUserDefaultsUtils {
    static let themeKey = "theme"
    static var theme: Int {
        return UserDefaults.theme.integer(forKey: themeKey)
    }
    static let themeOptions: [String] = ["Light Theme", "Dark Theme", "Device Default"]
    static let themeLight: Int = 0
    static let themeDark: Int = 1
    static let themeDeviceDefault: Int = 2
    
    static let amoledDarkKey = "amoled_dark"
    static var amoledDark: Bool {
        return UserDefaults.theme.bool(forKey: amoledDarkKey)
    }
}
