//
// SubmitImagePostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-24
        
import Foundation
import MarkdownUI
import SwiftUI

@MainActor
class SubmitImagePostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    // This may be one frame in a GIF and it can be used as the poster when submitting the post
    @Published var image: UIImage? = nil
    // This contains the raw image data
    private var imageData: Data? = nil
    private var isGIF: Bool = false
    @Published var submitPostTask: Task<Void, Error>?
    @Published var postSubmittedFlag: Bool = false
    @Published var error: Error? = nil
    
    private let submitPostRepository: SubmitPostRepositoryProtocol
    private let mediaUploadRepository: MediaUploadRepositoryProtocol
    
    enum SubmitImagePostViewModelError: LocalizedError {
        case imageNotSelectedError
        case gifDataError
        
        var errorDescription: String? {
            switch self {
            case .imageNotSelectedError:
                return "Please select an image first."
            case .gifDataError:
                return "Cannot get GIF data. Please try selecting a different one."
            }
        }
    }
    
    init(submitPostRepository: SubmitPostRepositoryProtocol, mediaUploadRepository: MediaUploadRepositoryProtocol) {
        self.selectedAccount = AccountViewModel.shared.account
        self.submitPostRepository = submitPostRepository
        self.mediaUploadRepository = mediaUploadRepository
    }
    
    func setImage(image: UIImage, imageData: Data? = nil, isGIF: Bool = false) {
        self.image = image
        self.imageData = imageData
        self.isGIF = isGIF
        print("Updated captured image: \(image.description)")
    }
    
    func clearCapturedImage() {
        image = nil
        print("Cleared captured image")
    }
    
    func submitPost(
        subreddit: SubscribedSubredditData?,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool,
        isRichTextJSON: Bool
    ) {
        guard submitPostTask == nil else {
            return
        }
        
        guard let subreddit = subreddit, !subreddit.name.isEmpty else {
            error = PostSubmissionError.subredditNotSelectedError
            return
        }
        
        guard !title.isEmpty else {
            error = PostSubmissionError.noTitleError
            return
        }
        
        guard let image else {
            error = SubmitImagePostViewModelError.imageNotSelectedError
            return
        }
        
        guard !(isGIF && imageData == nil) else {
            error = SubmitImagePostViewModelError.gifDataError
            return
        }
        
        postSubmittedFlag = false
        
        submitPostTask = Task {
            do {
                if isGIF {
                    let gifUrlString = try await mediaUploadRepository.uploadGIF(account: selectedAccount, gifData: imageData!)
                    let posterUrlString = try await mediaUploadRepository.uploadImage(account: selectedAccount, image: image)
                    
                    try await submitPostRepository.submitGifPost(
                        account: selectedAccount,
                        subredditName: subreddit.name,
                        title: title,
                        content: content,
                        gifUrlString: gifUrlString,
                        posterUrlString: posterUrlString,
                        flair: flair,
                        isSpoiler: isSpoiler,
                        isSensitive: isSensitive,
                        receivePostReplyNotifications: receivePostReplyNotifications,
                        isRichTextJSON: isRichTextJSON
                    )
                } else {
                    let imageUrlString = try await mediaUploadRepository.uploadImage(account: selectedAccount, image: image)
                    
                    try await submitPostRepository.submitImagePost(
                        account: selectedAccount,
                        subredditName: subreddit.name,
                        title: title,
                        content: content,
                        imageUrlString: imageUrlString,
                        flair: flair,
                        isSpoiler: isSpoiler,
                        isSensitive: isSensitive,
                        receivePostReplyNotifications: receivePostReplyNotifications,
                        isRichTextJSON: isRichTextJSON
                    )
                }
                
                postSubmittedFlag = true
            } catch {
                self.error = error
                print(error)
            }
            
            self.submitPostTask = nil
        }
    }
}
