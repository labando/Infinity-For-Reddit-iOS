//
//  SubmitCommentViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-17.
//

import Foundation
import MarkdownUI

class SubmitCommentViewModel: ObservableObject {
    @Published var selectedAccount: Account
    @Published var text: String = ""
    @Published var isSubmitting: Bool = false
    @Published var error: Error? = nil
    
    let commentParent: CommentParent
    
    private let submitCommentRepository: SubmitCommentRepositoryProtocol
    
    init(commentParent: CommentParent, submitCommentRepository: SubmitCommentRepositoryProtocol) {
        self.selectedAccount = AccountViewModel.shared.account
        self.commentParent = commentParent
        self.submitCommentRepository = submitCommentRepository
    }
    
    func submitComment() async {
        guard isSubmitting == false else { return }
        
        await MainActor.run {
            isSubmitting = true
        }
        
        do {
            let comment = try await submitCommentRepository.submitComment(
                accout: selectedAccount,
                content: text,
                parentFullname: commentParent.parentFullname ?? "",
                depth: commentParent.childCommentDepth
            )
            print(comment.body ?? "no body")
        } catch {
            await MainActor.run {
                self.error = error
            }
            print("Error submitting comment: \(error)")
        }
        
        await MainActor.run {
            isSubmitting = false
        }
    }
}
