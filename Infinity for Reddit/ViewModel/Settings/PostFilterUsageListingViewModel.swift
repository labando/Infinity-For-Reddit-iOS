//
//  PostFilterUsageViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-03.
//

import Foundation
import GRDB
import Combine

class PostFilterUsageListingViewModel: ObservableObject {
    @Published var postFilterUsages: [PostFilterUsage] = []
    @Published var error: Error?
    
    private let postFilterId: Int
    private let postFilterUsageRepository: PostFilterUsageListingRepositoryProtocol
    private let postFilterUsageDao: PostFilterUsageDao
    
    private var listener: AnyDatabaseCancellable?
    
    private let postFilterUsagesPublisher: AnyPublisher<[PostFilterUsage], Error>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(postFilterId: Int, postFilterUsageRepository: PostFilterUsageListingRepositoryProtocol) {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.postFilterId = postFilterId
        self.postFilterUsageRepository = postFilterUsageRepository
        self.postFilterUsageDao = PostFilterUsageDao(dbPool: resolvedDBPool)
        self.postFilterUsagesPublisher = postFilterUsageDao.getAllPostFilterUsageLiveData(postFilterId: postFilterId)
        
        postFilterUsagesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] postFilterUsages in
                self?.postFilterUsages = postFilterUsages
            })
            .store(in: &cancellables)
    }
    
    func savePostFilterUsage(usageType: PostFilterUsage.UsageType, nameOfUsage: String?) {
        Task {
            let postFilterUsage = PostFilterUsage(postFilterId: postFilterId, usageType: usageType, nameOfUsage: nameOfUsage)
            do {
                try await postFilterUsageRepository.savePostFilterUsage(postFilterUsage)
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func savePostFilterUsages(usageType: PostFilterUsage.UsageType, things: [Thing]) {
        Task {
            let postFilterUsages: [PostFilterUsage] = things.compactMap {
                switch ($0, usageType) {
                case (.subscribedSubreddit(let subscribedSubredditData), .subreddit):
                    return PostFilterUsage(postFilterId: postFilterId, usageType: usageType, nameOfUsage: subscribedSubredditData.name)
                case (.subreddit(let subredditData), .subreddit):
                    return PostFilterUsage(postFilterId: postFilterId, usageType: usageType, nameOfUsage: subredditData.name)
                case (.subscribedUser(let subscribedUserData), .user):
                    return PostFilterUsage(postFilterId: postFilterId, usageType: usageType, nameOfUsage: subscribedUserData.name)
                case (.user(let userData), .user):
                    return PostFilterUsage(postFilterId: postFilterId, usageType: usageType, nameOfUsage: userData.name)
                case (.myCustomFeed(let myCustomFeed), .customFeed):
                    return PostFilterUsage(postFilterId: postFilterId, usageType: usageType, nameOfUsage: myCustomFeed.path)
                default:
                    return nil
                }
            }
            do {
                try await postFilterUsageRepository.savePostFilterUsages(postFilterUsages)
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
    
    func deletePostFilterUsage(_ postFilterUsage: PostFilterUsage) {
        Task {
            do {
                try await postFilterUsageRepository.deletePostFilterUsage(postFilterUsage)
            } catch {
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
}
