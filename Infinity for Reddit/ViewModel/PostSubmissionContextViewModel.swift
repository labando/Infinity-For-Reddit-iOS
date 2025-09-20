//
// PostSubmissionContextViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-24

import Foundation

@MainActor
class PostSubmissionContextViewModel: ObservableObject {
    @Published var selectedSubreddit: SubscribedSubredditData? = nil {
        didSet {
            error = nil
            isLoadingRules = false
            isLoadingFlairs = false
            
            if let name = selectedSubreddit?.name {
                rules = allRules[name] ?? []
                flairs = allFlairs[name] ?? []
            } else {
                rules = []
                flairs = []
            }
        }
    }
    @Published var error: Error?
    @Published var rules: [Rule] = []
    @Published var flairs: [Flair] = []
    
    @Published var isLoadingRules: Bool = false
    @Published var isLoadingFlairs: Bool = false
    
    private var allRules: [String: [Rule]] = [:]
    private var allFlairs: [String: [Flair]] = [:]
    
    private var ruleRepository: RuleRepositoryProtocol
    private var flairRepository: FlairRepositoryProtocol
    
    init(ruleRepository: RuleRepositoryProtocol, flairRepository: FlairRepositoryProtocol) {
        self.ruleRepository = ruleRepository
        self.flairRepository = flairRepository
    }
    
    func fetchRules(forceFetch: Bool = false) async {
        guard let subredditName = selectedSubreddit?.name, !subredditName.isEmpty else {
            self.rules = []
            return
        }
        
        if !forceFetch, let cached = allRules[subredditName] {
            self.rules = cached
            return
        }
        
        isLoadingRules = true
        error = nil
        
        do {
            try Task.checkCancellation()
            
            let fetched = try await ruleRepository.fetchRules(subredditName: subredditName)
            
            rules = fetched
            allRules[subredditName] = fetched
        } catch {
            rules = []
            self.error = error
        }
        
        isLoadingRules = false
    }
    
    func fetchFlairs(forceFetch: Bool = false) async {
        guard let subredditName = selectedSubreddit?.name, !subredditName.isEmpty else { return }
        
        if !forceFetch, let cached = allFlairs[subredditName] {
            self.flairs = cached
            return
        }
        
        isLoadingFlairs = true
        error = nil
        
        do {
            try Task.checkCancellation()
            
            let fetched = try await flairRepository.fetchFlairs(subreddit: subredditName)
            
            flairs = fetched
            allFlairs[subredditName] = fetched
        } catch {
            self.error = error
            flairs = []
        }
        
        isLoadingFlairs = false
    }
}
