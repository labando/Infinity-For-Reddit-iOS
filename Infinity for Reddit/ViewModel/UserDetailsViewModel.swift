//
//  UserDetailsViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-02-11.
//

import Foundation
import SwiftUI

@MainActor
class UserDetailsViewModel: ObservableObject {
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    let username: String
    @Published var userData: UserData?
    @Published var userBlockedFlag: Bool = false
    @Published var error: Error?
    
    private let userDetailsRepository: UserDetailsRepositoryProtocol
    private var followUserTask: Task<Void, Never>?
    private var blockUserTask: Task<Void, Never>?
    
    init(username: String, userDetailsRepository: UserDetailsRepositoryProtocol) {
        self.username = username
        self.userDetailsRepository = userDetailsRepository
    }
    
    enum UserDetailsError: LocalizedError {
        case loginRequired
        case blockUserFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .loginRequired:
                return "You must be logged in to perform that action."
            case .blockUserFailed(let error):
                return "Failed to block user. Try again later."
            }
        }
    }
    
    func fetchUserDetails() async {
        do {
            try Task.checkCancellation()
            
            let userData = try await userDetailsRepository.fetchUserDetails(username: username)
            
            try Task.checkCancellation()
            
            self.userData = userData
        } catch {
            self.error = error
            
            print("Error fetching user data: \(error)")
        }
    }
    
    func toggleFollowUser() {
        guard let userData else {
            return
        }
        
        followUserTask?.cancel()
        followUserTask = Task {
            let action = userData.isSubscribed ? "unsub" : "sub"
            do {
                try await userDetailsRepository.followUser(userData: userData, action: action)
                
                try Task.checkCancellation()
                
                self.userData?.isSubscribed = action == "sub"
            } catch {
                self.error = error
                
                print("Error \(action == "sub" ? "following" : "unfollowing") \(username): \(error)")
            }
            
            followUserTask = nil
        }
    }
    
    func blockUser() {
        guard !AccountViewModel.shared.account.isAnonymous() else {
            self.error = UserDetailsError.loginRequired
            return
        }
        
        blockUserTask?.cancel()
        blockUserTask = Task {
            do {
                try await userDetailsRepository.blockUser(username: username)
                
                userBlockedFlag.toggle()
            } catch {
                self.error = UserDetailsError.blockUserFailed(error)
            }
            
            blockUserTask = nil
        }
    }
}
