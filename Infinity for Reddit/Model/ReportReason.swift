//
//  ReportReason.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

enum ReportReason {
    case siteReason(reason: String)
    case ruleReason(shortName: String)
    case otherReason
    
    var type: String {
        switch self {
        case .siteReason:
            return "site_reason"
        case .ruleReason:
            return "rule_reason"
        case .otherReason:
            return "other_reason"
        }
    }
    
    var reason: String {
        switch self {
        case .siteReason(let reason):
            return reason
        case .ruleReason(let shortName):
            return shortName
        case .otherReason:
            return ""
        }
    }
    
    var reasonValue: String {
        switch self {
        case .siteReason:
            return "site_reason_selected"
        case .ruleReason:
            return "rule_reason_selected"
        case .otherReason:
            return "other"
        }
    }
}
