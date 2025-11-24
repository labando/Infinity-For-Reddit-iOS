//
//  ReportViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import Foundation

@MainActor
class ReportViewModel: ObservableObject {
    @Published var rules: [Rule] = []
    @Published var ruleLoadState: LoadState = .idle
    @Published var selectedReportReason: ReportReason?
    @Published var error: Error?
    
    let siteReasons: [String] = [
        "This post is spam.",
        "This post is offensive.",
        "This post is inappropriate.",
        "This post is misleading.",
        "This post is harmful.",
    ]
    
    private let subredditName: String
    private let thingFullname: String
    private let reportRepository: ReportRepositoryProtocol
    private let ruleRepository: RuleRepositoryProtocol
    
    init(subredditName: String, thingFullname: String, reportRepository: ReportRepositoryProtocol, ruleRepository: RuleRepositoryProtocol) {
        self.subredditName = subredditName
        self.thingFullname = thingFullname
        self.reportRepository = reportRepository
        self.ruleRepository = ruleRepository
    }
    
    func fetchRules() async {
        guard ruleLoadState.canLoad else {
            return
        }
        
        ruleLoadState = .loading
        error = nil
        
        do {
            try Task.checkCancellation()
            
            self.rules = try await ruleRepository.fetchRules(subredditName: subredditName)
            
            ruleLoadState = .loaded
        } catch {
            rules = []
            self.error = error
            ruleLoadState = .failed(error)
        }
    }
    
    func selectSiteReason(_ reason: String) {
        selectedReportReason = .siteReason(reason: reason)
    }
    
    func selectRuleReason(_ rule: Rule) {
        selectedReportReason = .ruleReason(shortName: rule.shortName)
    }
    
    func isSelected(reason: String) -> Bool {
        guard let selectedReportReason else {
            return false
        }
        
        switch selectedReportReason {
        case .siteReason(let siteReason):
            return reason == siteReason
        default:
            return false
        }
    }
    
    func isSelected(rule: Rule) -> Bool {
        guard let selectedReportReason else {
            return false
        }
        
        switch selectedReportReason {
        case .ruleReason(let shortName):
            return shortName == rule.shortName
        default:
            return false
        }
    }
}
