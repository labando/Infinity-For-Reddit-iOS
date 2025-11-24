//
//  ReportRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

protocol ReportRepositoryProtocol {
    func report(subredditName: String, thingFullname: String, reportReason: ReportReason) async throws
}
