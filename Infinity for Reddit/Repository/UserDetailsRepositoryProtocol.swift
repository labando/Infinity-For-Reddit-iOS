//
//  UserDetailsRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-04.
//

import Combine

public protocol UserDetailsRepositoryProtocol {
    func fetchUserDetails(username: String) async throws -> UserData
    func followUser(username: String, action: String) async throws
}
