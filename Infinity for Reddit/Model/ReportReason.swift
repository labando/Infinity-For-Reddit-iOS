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
    
    var value: String {
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
