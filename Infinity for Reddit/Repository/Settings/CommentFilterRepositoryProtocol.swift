//
//  CommentFilterRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

public protocol CommentFilterRepositoryProtocol {
    func deleteCommentFilter(id: Int) async throws
}
