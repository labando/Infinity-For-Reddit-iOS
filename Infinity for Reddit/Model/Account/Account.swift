//
//  Account.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-01.
//

import GRDB

struct Account: Codable, FetchableRecord, PersistableRecord {
    static let ANONYMOUS_ACCOUNT = "-"
    static let databaseTableName = "accounts"
    
    var username: String
    var isCurrentUser: Bool
    var profileImageUrl: String?
    var bannerImageUrl: String?
    var karma: Int
    var accessToken: String?
    var refreshToken: String?
}
