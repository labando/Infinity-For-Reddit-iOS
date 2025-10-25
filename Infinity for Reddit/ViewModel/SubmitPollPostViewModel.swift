//
// SubmitPollPostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-10-24
        
import Foundation
import MarkdownUI
import SwiftyJSON
import UIKit
import SwiftUI

@MainActor
class SubmitPollPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var embeddedImages: [UploadedImage] = []
    @Published var submitPostTask: Task<Void, Error>?
    @Published var submittedPostId: String?
    @Published var error: Error? = nil
    
    private let submitPostRepository: SubmitPostRepositoryProtocol
    private let mediaUploadRepository: MediaUploadRepositoryProtocol
    
    init(submitPostRepository: SubmitPostRepositoryProtocol, mediaUploadRepository: MediaUploadRepositoryProtocol) {
        self.selectedAccount = AccountViewModel.shared.account
        self.submitPostRepository = submitPostRepository
        self.mediaUploadRepository = mediaUploadRepository
    }
    
    func addEmbeddedImage(_ image: UIImage) {
        let embeddedImage = UploadedImage(image: image) {
            try await self.mediaUploadRepository.uploadImage(account: self.selectedAccount, image: image, getImageId: true)
        }
        embeddedImage.upload()
        embeddedImages.append(embeddedImage)
    }
    
    func submitPost() async {
        // TODO: submitPollPost logic
    }
}
