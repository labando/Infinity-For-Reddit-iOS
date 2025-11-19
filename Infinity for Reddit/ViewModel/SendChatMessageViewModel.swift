//
//  SendChatMessageViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import Foundation

class SendChatMessageViewModel: ObservableObject {
    @Published var username: String
    @Published var subject: String = ""
    @Published var message: String = ""
    
    private let sendChatMessageRepository: SendChatMessageRepositoryProtocol
    
    init(username: String?, sendChatMessageRepository: SendChatMessageRepositoryProtocol) {
        self.username = username ?? ""
        self.sendChatMessageRepository = sendChatMessageRepository
    }
}
