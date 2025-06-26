//
//  CommentViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-17.
//  

import Foundation
import Alamofire
import Combine

@MainActor
public class CommentViewModel: ObservableObject {
    let account: Account
    @Published var comment: Comment
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    let commentRepository: CommentRepositoryProtocol
    
    public init(account: Account, comment: Comment, commentRepository: CommentRepositoryProtocol) {
        self.account = account
        self.comment = comment
        self.commentRepository = commentRepository
        comment.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func voteComment(vote: Int) async {
        guard let _ = account.accessToken, let _ = comment.name else { return }
        
        let previousVote = comment.likes
        
        var point: String
        let finalVote: Int
        if vote == comment.likes {
            point = "0"
            finalVote = 0
            comment.likes = 0
        } else {
            point = String(vote)
            finalVote = vote
            comment.likes = vote
        }
        self.objectWillChange.send()
        
        defer {
            self.objectWillChange.send()
        }
        
        do {
            try await commentRepository.voteComment(comment: comment, point: point)
            self.comment.likes = finalVote
        } catch {
            self.comment.likes = previousVote
            self.error = error
            print("Error voting comment: \(error)")
        }
    }
    
    func saveComment(save: Bool) async {
        guard let _ = account.accessToken, let _ = comment.name else { return }
        
        let previousSaved = comment.saved
        
        comment.saved = save
        
        self.objectWillChange.send()
        
        defer {
            self.objectWillChange.send()
        }
        
        do {
            try await commentRepository.saveComment(comment: comment, save: save)
        } catch {
            self.comment.saved = previousSaved
            self.error = error
            print("Error (un)saving comment: \(error)")
        }
    }
}
