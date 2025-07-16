//
//  ContentSensitivityFilterUserDetailsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-16.
//

import Foundation

enum ContentSensitivityFilterUserDetailsUtils {
    static let sensitiveContentKey = "sensitive_content"
    static var sensitiveContent: Bool {
        return UserDefaults.contentSensitivityFilter.bool(forKey: sensitiveContentKey)
    }
}
