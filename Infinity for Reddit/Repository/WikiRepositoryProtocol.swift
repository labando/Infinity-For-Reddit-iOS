//
//  WikiRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-25.
//

protocol WikiRepositoryProtocol {
    func fetchWiki(subredditName: String, wikiPath: String) async throws -> String
}
