//
//  RedditAccessTokenKeychainManager.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2026-02-15.
//

import Security
import Foundation

final class RedditAccessTokenKeychainManager {
    static let shared = RedditAccessTokenKeychainManager()

    private init() {}
    
    func saveAccessToken(accountName: String, accessToken: String) throws {
        try saveToken(accountName: accountName, token: accessToken, keyPrefix: "access_token_")
    }
    
    func saveRefreshToken(accountName: String, refreshToken: String) throws {
        try saveToken(accountName: accountName, token: refreshToken, keyPrefix: "refresh_token_")
    }
    
    private func saveToken(accountName: String, token: String, keyPrefix: String) throws {
        if let data = token.data(using: .utf8) {
            if let existingData = try? getToken(accountName: accountName, keyPrefix: keyPrefix) {
                // Access token exists
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: "\(keyPrefix)\(accountName)"
                ]
                let attributes: [String: Any] = [
                    kSecValueData as String: data
                ]
                
                var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
                if status == errSecItemNotFound {
                    throw KeychainError.itemNotFound
                }
            } else {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: "\(keyPrefix)\(accountName)",
                    kSecValueData as String: data,
                    kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
                ]
                
                let status = SecItemAdd(query as CFDictionary, nil)
                guard status != errSecDuplicateItem else {
                    throw KeychainError.duplicateItem
                }
                
                guard status == errSecSuccess else {
                    throw KeychainError.unknown(status)
                }
            }
        }
    }
    
    func getAccessToken(accountName: String) throws -> String? {
        return try getToken(accountName: accountName, keyPrefix: "access_token_")
    }
    
    func getRefreshToken(accountName: String) throws -> String? {
        return try getToken(accountName: accountName, keyPrefix: "refresh_token_")
    }
    
    private func getToken(accountName: String, keyPrefix: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "\(keyPrefix)\(accountName)",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        throw KeychainError.itemNotFound
    }
}
