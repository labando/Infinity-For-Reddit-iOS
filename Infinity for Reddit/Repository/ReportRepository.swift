//
//  ReportRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import Alamofire

class ReportRepository: ReportRepositoryProtocol {
    private let session: Session
    
    public init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session in ReportRepository")
        }
        self.session = resolvedSession
    }
    
    func report(subredditName: String, thingFullname: String, reportReason: ReportReason) async throws {
        let params = ["thing_id": thingFullname, "sr_name": subredditName, reportReason.type: reportReason.reason, "reason": reportReason.reasonValue, "api_type": "json"]
        
        try Task.checkCancellation()
        
        _ = try await self.session.request(RedditOAuthAPI.report(params: params))
            .validate()
            .serializingData()
            .value
    }
}
