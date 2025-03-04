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

class UserDetailsViewModel: ObservableObject {
    @EnvironmentObject var accountViewModel: AccountViewModel

    @Published var username: String
    @Published var userData: UserData?
    @Published var isSubscribed: Bool = false
    
    private let session: Session
    private var cancellables = Set<AnyCancellable>()
    
    private let userDetailsRepository: UserDetailsRepositoryProtocol
    
    init(username: String, userDetailsRepository: UserDetailsRepositoryProtocol) {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        self.session = resolvedSession
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
    
    func toggleFollowUser() {
        followUser(username: username, action: isSubscribed ? "unsub" : "sub")
    }
    
    private func followUser(username: String, action: String) {
        userDetailsRepository.followUser(username: username, action: action)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    print("Error \(action == "sub" ? "following to" : "unfollowing from") \(username): \(failure)")
                    self?.objectWillChange.send()
                } else {
                    self?.isSubscribed = action == "sub"
                    self?.objectWillChange.send()
                }
            }, receiveValue: {})
            .store(in: &cancellables)
    }
    
    func fetchUserDetails() {
        userDetailsRepository.fetchUserDetails(username: username)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    print("Error fetching user data:", failure)
                }
            }, receiveValue: { userData in
                self.userData = userData
            })
            .store(in: &cancellables)
    }
}
