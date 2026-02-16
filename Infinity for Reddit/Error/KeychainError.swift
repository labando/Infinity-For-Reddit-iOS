//
//  KeychainError.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2026-02-15.
//

import Foundation

enum KeychainError: Error {
    case duplicateItem
    case itemNotFound
    case unknown(OSStatus)
}
