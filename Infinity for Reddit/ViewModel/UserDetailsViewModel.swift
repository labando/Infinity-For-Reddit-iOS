//
//  UserDetailsViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-02-11.
//

import Foundation
import GRDB
import Combine
import Swinject
import Alamofire
import SwiftUI
import SwiftyJSON

@MainActor
class UserDetailsViewModel: ObservableObject {
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @Published var username: String
    @Published var userData: UserData?
    @Published var isSubscribed: Bool = false
    @Published var error: Error?
    
    private let session: Session
    private let dbPool: DatabasePool
    
    private let userDetailsRepository: UserDetailsRepositoryProtocol
    
    init(username: String, userDetailsRepository: UserDetailsRepositoryProtocol) {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError( "Failed to resolve DatabasePool")
        }
        self.session = resolvedSession
        self.dbPool = resolvedDBPool
        self.username = username
        self.userDetailsRepository = userDetailsRepository
    }
    
    func formattedCakeDay(_ timestamp: TimeInterval?) -> String {
        guard let timestamp = timestamp else {
            return "Unknown"
        }
        
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
    func toggleFollowUser() async {
        await followUser(username: username, action: isSubscribed ? "unsub" : "sub")
    }
    
    private func followUser(username: String, action: String) async {
        do {
            try Task.checkCancellation()
            
            if !AccountViewModel.shared.account.isAnonymous() {
                try await userDetailsRepository.followUser(username: username, action: action)
            }
            
            try Task.checkCancellation()
            
            let subscribedUserDao = SubscribedUserDao(dbPool: dbPool)
            if action == "unsub" {
                try subscribedUserDao.deleteSubscribedUser(name: username, accountName: AccountViewModel.shared.account.username)
            } else {
                if let userData = self.userData {
                    let subscribedUserData = SubscribedUserData(
                        name: username,
                        iconUrl: userData.iconUrl,
                        username: AccountViewModel.shared.account.username,
                        isFavorite: false
                    )
                    try subscribedUserDao.insert(subscribedUserData: subscribedUserData)
                }
                
            }
            
            self.isSubscribed = action == "sub"
        } catch {
            self.error = error
            
            print("Error \(action == "sub" ? "following to" : "unfollowing from") \(username): \(error)")
        }
    }
    
    func fetchUserDetails() async {
        do {
            try Task.checkCancellation()
            
            let fetchData = try await userDetailsRepository.fetchUserDetails(username: username)
            
            try Task.checkCancellation()
            
            self.userData = fetchData
            
            let subscribedUserDao = SubscribedUserDao(dbPool: dbPool)
            let isSubscribedUser = try subscribedUserDao.getSubscribedUser(name: fetchData.name, accountName: AccountViewModel.shared.account.username) != nil
            self.isSubscribed = isSubscribedUser
            
            do {
                let userDao = UserDao(dbPool: dbPool)
                try userDao.insert(userData: fetchData)
            } catch {
                print("Error: Failed to insert userData - \(error.localizedDescription)")
            }
            
        } catch {
            self.error = error
            
            print("Error fetching user data: \(error)")
        }
    }
}
