//
//  WikiViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-25.
//

import Foundation

@MainActor
class WikiViewModel: ObservableObject {
    @Published var wiki: String?
    @Published var wikiLoadState: LoadState = .idle
    @Published var wikiTaskTrigger: Bool = false
    @Published var error: Error?
    
    private let subredditName: String
    private let wikiPath: String
    private let wikiRepository: WikiRepositoryProtocol
    
    init(subedditName: String, wikiPath: String, wikiRepository: WikiRepositoryProtocol) {
        self.subredditName = subedditName
        self.wikiPath = wikiPath
        self.wikiRepository = wikiRepository
    }
    
    func fetchWiki() async {
        guard wikiLoadState.canLoad else {
            return
        }
        
        guard wiki == nil else {
            return
        }
        
        self.wikiLoadState = .loading
        
        do {
            self.wiki = try await wikiRepository.fetchWiki(subredditName: subredditName, wikiPath: wikiPath)
            self.wikiLoadState = .loaded
        } catch {
            self.error = error
            self.wikiLoadState = .failed(error)
            print(error)
        }
    }
}
