//
//  UserProfileImageBatchLoader.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-24.
//

import Foundation
import Alamofire
import SwiftyJSON

actor UserProfileImageBatchLoader {
    enum UserProfileImageBatchLoaderError: Error {
        case NetworkError(String)
        case JSONDecodingError(String)
    }
    
    static let shared = UserProfileImageBatchLoader()
    
    private let session: Session
    public static let batchSize = 100
    private var cache: [String: URL?] = [:]
    private var inFlight: Set<String> = []
    private var loadingQueue: [String] = []
    private var waitingContinuations: [String: [CheckedContinuation<URL?, Never>]] = [:]
    
    private var isLoading = false
    
    private init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        self.session = resolvedSession
    }
    
    func loadIcons(for comments: [Comment]) async -> URL? {
        guard let callingAuthor = comments.first?.authorFullname else {
            return nil
        }
        
        if let cached = cache[callingAuthor] {
            return cached
        }
        
        if inFlight.contains(callingAuthor) {
            return await withCheckedContinuation { continuation in
                waitingContinuations[callingAuthor, default: []].append(continuation)
            }
        }
        
        let batch = comments
            .map(\.authorFullname)
            .filter { !cache.keys.contains($0) && !inFlight.contains($0) }
            .prefix(UserProfileImageBatchLoader.batchSize)
        
        for author in batch {
            inFlight.insert(author)
        }
        
        loadingQueue.append(contentsOf: batch)
        
        Task {
            await processNextBatchIfNeeded()
        }
        
        return await withCheckedContinuation { continuation in
            waitingContinuations[callingAuthor, default: []].append(continuation)
        }
    }
    
    private func processNextBatchIfNeeded() async {
        guard !isLoading, !loadingQueue.isEmpty else { return }

        isLoading = true

        let batch = Array(loadingQueue.prefix(UserProfileImageBatchLoader.batchSize))
        loadingQueue.removeFirst(min(UserProfileImageBatchLoader.batchSize, loadingQueue.count))

        do {
            let result = try await fetchIcons(for: batch)

            for author in batch {
                let url = result[author] ?? nil
                resumeWaiters(author: author, url: url)
            }
        } catch {
            for author in batch {
                resumeWaiters(author: author, url: nil)
            }
        }

        isLoading = false
        await processNextBatchIfNeeded()
    }
    
    private func fetchIcons(for authors: [String]) async throws -> [String: URL?] {
        try Task.checkCancellation()
        
        let data = try await self.session.request(
            RedditAPI.getPartialUserData(queries: ["ids": authors.joined(separator: ",")])
        )
            .validate()
            .serializingData(automaticallyCancelling: true)
            .value
        
        try Task.checkCancellation()
        
        let json = JSON(data)
        if let error = json.error {
            throw UserProfileImageBatchLoaderError.JSONDecodingError(error.localizedDescription)
        }
        
        let partialUserDataListing = try PartialUserDataListing(fromJson: json)
        
        let result: [String: URL?] = partialUserDataListing.partialUserDataDictionary.mapValues { partialUserData in
            URL(string: partialUserData.profileImg ?? "")
        }
        
        return result
    }
    
    private func resumeWaiters(author: String, url: URL?) {
        cache[author] = url
        inFlight.remove(author)
        if let continuations = waitingContinuations[author] {
            for continuation in continuations {
                continuation.resume(returning: url)
            }
            waitingContinuations[author] = nil
        }
    }
}
