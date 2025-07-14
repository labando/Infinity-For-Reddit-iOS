//
//  PostDetailsInput.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-14.
//

enum PostDetailsInput: Hashable {
    case post(Post)
    case postAndCommentId(postId: String, commentId: String?)
}
