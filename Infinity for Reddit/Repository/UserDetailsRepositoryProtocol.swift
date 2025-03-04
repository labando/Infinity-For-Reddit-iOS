//
//  UserDetailsRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-04.
//

import Combine

public protocol UserDetailsRepositoryProtocol {
    func fetchUserDetails(username: String) -> AnyPublisher<UserData, Error>
    func followUser(username: String, action: String) -> AnyPublisher<Void, Error>
}
