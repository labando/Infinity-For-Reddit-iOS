//
//  CopyCustomFeedViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import Foundation
import IdentifiedCollections

@MainActor
class CopyCustomFeedViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var subredditsAndUsersInCustomFeed: IdentifiedArrayOf<Thing> = []
    @Published var copyCustomFeedTask: Task<Void, Never>?
    @Published var copiedMyCustomFeed: MyCustomFeed?
    @Published var error: Error? = nil

    @Published var customFeedLoadState: LoadState = .idle
    
    private let path: String
    private let copyCustomFeedRepository: CopyCustomFeedRepositoryProtocol
    
    enum CopyCustomFeedViewModelError: LocalizedError {
        case emptyNameError
        
        var errorDescription: String? {
            switch self {
            case .emptyNameError:
                return "Name cannot be empty."
            }
        }
    }
    
    init(path: String, copyCustomFeedRepository: CopyCustomFeedRepositoryProtocol) {
        self.path = path
        self.copyCustomFeedRepository = copyCustomFeedRepository
    }
    
    func fetchCustomFeedDetailsToCopy() async {
        guard customFeedLoadState.canLoad else {
            return
        }

        customFeedLoadState = .loading
        
        do {
            let customFeed = try await copyCustomFeedRepository.fetchCustomFeedDetails(path: path)
            
            name = customFeed.name
            description = customFeed.descriptionMd
            for thingInCustomFeed in customFeed.subredditsInCustomFeed {
                subredditsAndUsersInCustomFeed.append(.subredditInCustomFeed(thingInCustomFeed))
            }
            
            customFeedLoadState = .loaded
        } catch {
            customFeedLoadState = .failed(error)
        }
    }
    
    func copyCustomFeed() {
        guard copyCustomFeedTask == nil else {
            return
        }
        
        guard customFeedLoadState.isLoaded else {
            return
        }
        
        guard !name.isEmpty else {
            self.error = CopyCustomFeedViewModelError.emptyNameError
            return
        }
        
        copyCustomFeedTask = Task {
            do {
                self.copiedMyCustomFeed = try await copyCustomFeedRepository.copyCustomFeed(
                    path: path,
                    name: name,
                    description: description,
                    subredditsAndUsersInCustomFeed: subredditsAndUsersInCustomFeed
                )
            } catch {
                self.error = error
                print(error)
            }
            
            copyCustomFeedTask = nil
        }
    }
}
