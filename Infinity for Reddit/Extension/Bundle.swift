//
//  Bundle.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-12-11.
//

import Foundation

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
}
