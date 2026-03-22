//
// SubmitVideoPostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-10-19

import Foundation
import MarkdownUI
import SwiftUI
import AVFoundation
import PhotosUI

@MainActor
class SubmitVideoPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var videoURL: URL? = nil
    @Published var thumbnail: UIImage? = nil
    @Published var submitPostTask: Task<Void, Error>?
    @Published var postSubmittedFlag: Bool = false
    @Published var error: Error? = nil
    
    private let submitPostRepository: SubmitPostRepositoryProtocol
    private let mediaUploadRepository: MediaUploadRepositoryProtocol
    
    init(submitPostRepository: SubmitPostRepositoryProtocol, mediaUploadRepository: MediaUploadRepositoryProtocol) {
        self.selectedAccount = AccountViewModel.shared.account
        self.submitPostRepository = submitPostRepository
        self.mediaUploadRepository = mediaUploadRepository
    }
    
    func processVideo(videoItem: PhotosPickerItem) async {
        videoURL = nil
        thumbnail = nil
        
        do {
            if let video = try await videoItem.loadTransferable(type: LocalVideo.self) {
                try await setVideo(url: video.url)
            } else {
                throw PostSubmissionError.videoLoadingError
            }
        } catch {
            self.error = error
        }
    }
    
    func setVideo(url: URL) async throws {
        printInDebugOnly(url)
        
        if let image = await generateThumbnail(for: url) {
            if !Task.isCancelled {
                self.videoURL = url
                self.thumbnail = image
            }
        } else {
            throw PostSubmissionError.videoThumbnailError
        }
    }
    
    func setCapturedVideo(url: URL) async {
        do {
            try await setVideo(url: url)
        } catch {
            self.error = error
        }
    }
    
    func clearVideo() {
        videoURL = nil
        thumbnail = nil
    }
    
    func generateThumbnail(for url: URL) async -> UIImage? {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 0, preferredTimescale: 600)

        do {
            return try await withCheckedThrowingContinuation { continuation in
                generator.generateCGImageAsynchronously(for: time) { cgImage, _, error in
                    if let cgImage = cgImage {
                        continuation.resume(returning: UIImage(cgImage: cgImage))
                    } else {
                        printInDebugOnly("Thumbnail generation failed:", error?.localizedDescription ?? "unknown error")
                        continuation.resume(returning: nil)
                    }
                }
            }
        } catch {
            self.error = error
        }
        
        return nil
    }
    
    func submitPost(
        subreddit: SubscribedSubredditData?,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool
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
        
        guard let videoURL else {
            error = PostSubmissionError.videoNotSelectedError
            return
        }
        
        guard let thumbnail else {
            error = PostSubmissionError.videoThumbnailError
            return
        }
        
        postSubmittedFlag = false
        
        submitPostTask = Task {
            do {
                let videoUrlString = try await mediaUploadRepository.uploadVideo(account: selectedAccount, videoURL: videoURL)
                let posterUrlString = try await mediaUploadRepository.uploadImage(account: selectedAccount, image: thumbnail, getImageId: false)
                
                try await submitPostRepository.submitVideoPost(
                    account: selectedAccount,
                    subredditName: subreddit.name,
                    title: title,
                    content: content,
                    videoUrlString: videoUrlString,
                    posterUrlString: posterUrlString,
                    flair: flair,
                    isSpoiler: isSpoiler,
                    isSensitive: isSensitive,
                    receivePostReplyNotifications: receivePostReplyNotifications
                )
                
                postSubmittedFlag = true
            } catch {
                self.error = error
                printInDebugOnly(error)
            }
            
            self.submitPostTask = nil
        }
    }
}
