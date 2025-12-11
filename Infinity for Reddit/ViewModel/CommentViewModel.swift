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
class CommentViewModel: ObservableObject {
    let account: Account
    @Published var comment: Comment
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    let commentRepository: CommentRepositoryProtocol
    let thingModerationRepository: ThingModerationRepositoryProtocol
    
    init(account: Account, comment: Comment, commentRepository: CommentRepositoryProtocol, thingModerationRepository: ThingModerationRepositoryProtocol) {
        self.account = account
        self.comment = comment
        self.commentRepository = commentRepository
        self.thingModerationRepository = thingModerationRepository
        comment.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
