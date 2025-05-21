//
// SubredditDetailsViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-05-02

import Foundation
import GRDB
import Combine
import Swinject
import Alamofire
import SwiftUI
import SwiftyJSON

@MainActor
class SubredditDetailsViewModel: ObservableObject {    
    @Published var subredditName: String
    @Published var subredditData: SubredditData?
    @Published var isSubscribed: Bool = false
    @Published var error: Error?
    
    private let session: Session
    private let dbPool: DatabasePool
    
    public let subredditDetailsRepository: SubredditDetailsRepositoryProtocol
    
    // MARK: - Initializer
    init(subredditName: String, subredditDetailsRepository: SubredditDetailsRepositoryProtocol) {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError( "Failed to resolve DatabasePool")
        }
        self.session = resolvedSession
        self.dbPool = resolvedDBPool
        self.subredditName = subredditName
        self.subredditDetailsRepository = subredditDetailsRepository
        
    }
    
    // MARK: - Methods
    func toggleSubscribeSubreddit() async {
        await subscribeSubreddit(subredditName: subredditName, action: isSubscribed ? "unsub" : "sub")
    }
    
    private func subscribeSubreddit(subredditName: String, action: String) async {
        do {
            try Task.checkCancellation()
            
            try await subredditDetailsRepository.subsribeSubreddit(subredditName: subredditName, action: action)
            
            try Task.checkCancellation()
            do {
                let subredditDao = SubredditDao(dbPool: dbPool)
                try subredditDao.updateSubscription(isSubscribed: action == "sub" ? true : false)
            } catch {
                print("Error: Failed to update subscription in subredditData: \(error)")
            }

            self.isSubscribed = action == "sub"
            
        } catch {
            self.error = error
            
            print("Error \(action == "sub" ? "subscribing to" : "unsubscribing from") \(subredditName): \(error)")
        }
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
    
    func fetchSubredditDetails() async {
        do {
            try Task.checkCancellation()
            
            let fetchData = try await subredditDetailsRepository.fetchSubredditDetails(subredditName: subredditName)
            
            try Task.checkCancellation()
            
            do {
                let subredditDao = SubredditDao(dbPool: dbPool)
                try subredditDao.insert(subredditData: fetchData)
            } catch {
                print("Error: Failed to insert subredditData - \(error.localizedDescription)")
            }
             
            self.subredditData = fetchData
            if let isJoined = self.subredditData?.isSubscribed {
                isSubscribed = isJoined
            }
            
        } catch {
            self.error = error
            
            print("Error fetching user data: \(error)")
        }
    }
}
