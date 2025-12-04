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
            selectedFlair = nil
            rulesError = nil
            flairsError = nil
            isLoadingRules = false
            isLoadingFlairs = false
            rules = []
            flairs = []
        }
    }
    @Published var selectedFlair: Flair?
    @Published var isSpoiler: Bool = false
    @Published var isSensitive: Bool = false
    @Published var receivePostReplyNotification: Bool = true
    
    @Published var rulesError: Error?
    @Published var flairsError: Error?
    @Published var rules: [Rule] = []
    @Published var flairs: [Flair] = []
    
    @Published var isLoadingRules: Bool = false
    @Published var isLoadingFlairs: Bool = false
    
    private var loadRulesTask: Task<Void, Error>?
    private var loadFlairsTask: Task<Void, Error>?
    
    private var allRules: [String: [Rule]] = [:]
    private var allFlairs: [String: [Flair]] = [:]
    
    private var ruleRepository: RuleRepositoryProtocol
    private var flairRepository: FlairRepositoryProtocol
    
    init(ruleRepository: RuleRepositoryProtocol, flairRepository: FlairRepositoryProtocol) {
        self.ruleRepository = ruleRepository
        self.flairRepository = flairRepository
    }
    
    func fetchRules(forceFetch: Bool = false) {
        guard loadRulesTask == nil, let subredditName = selectedSubreddit?.name, !subredditName.isEmpty else {
            return
        }
        
        if !forceFetch, let cached = allRules[subredditName] {
            self.rules = cached
            return
        }
        
        isLoadingRules = true
        rulesError = nil
        
        loadRulesTask = Task {
            do {
                try Task.checkCancellation()
                
                let fetched = try await ruleRepository.fetchRules(subredditName: subredditName)
                
                rules = fetched
                allRules[subredditName] = fetched
            } catch {
                rules = []
                self.rulesError = error
            }
            
            loadRulesTask = nil
            isLoadingRules = false
        }
    }
    
    func fetchFlairs(forceFetch: Bool = false) {
        guard loadFlairsTask == nil, let subredditName = selectedSubreddit?.name, !subredditName.isEmpty else { return }
        
        if !forceFetch, let cached = allFlairs[subredditName] {
            self.flairs = cached
            return
        }
        
        isLoadingFlairs = true
        flairsError = nil
        
        loadFlairsTask = Task {
            do {
                try Task.checkCancellation()
                
                let fetched = try await flairRepository.fetchFlairs(subreddit: subredditName)
                
                flairs = fetched
                allFlairs[subredditName] = fetched
            } catch {
                self.flairsError = error
                flairs = []
            }
            
            loadFlairsTask = nil
            isLoadingFlairs = false
        }
    }
}
