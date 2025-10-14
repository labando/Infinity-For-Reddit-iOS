//
//  SubmitPostRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-13.
//

import UIKit

protocol SubmitPostRepositoryProtocol {
    // Returns the ID of the submitted post
    func submitTextPost(
        account: Account,
        subredditName: String,
        title: String,
        content: String,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool,
        isRichTextJSON: Bool
    ) async throws -> String
    
    func submitImagePost(
        account: Account,
        subredditName: String,
        title: String,
        content: String,
        imageUrlString: String,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool,
        isRichTextJSON: Bool
    ) async throws
    
    func submitGifPost(
        account: Account,
        subredditName: String,
        title: String,
        content: String,
        gifUrlString: String,
        posterUrlString: String,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool,
        isRichTextJSON: Bool
    ) async throws
}
