//
//  SubmitCommentRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-21.
//

import GiphyUISDK

protocol SubmitCommentRepositoryProtocol {
    func submitComment(account: Account, content: String,  parentFullname: String, depth: Int, embeddedImages: [UploadedImage], giphyGif: GPHMedia?) async throws -> Comment
}
