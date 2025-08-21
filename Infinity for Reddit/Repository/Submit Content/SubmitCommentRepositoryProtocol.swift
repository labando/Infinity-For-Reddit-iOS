//
//  SubmitCommentRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-21.
//

protocol SubmitCommentRepositoryProtocol {
    func submitComment(accout: Account, content: String,  parentFullname: String, depth: Int) async throws -> Comment
}
