//
//  CommentRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-24.
//

import Combine
import Alamofire

public protocol CommentRepositoryProtocol {
    func voteComment(comment: Comment, point: String) async throws
}
