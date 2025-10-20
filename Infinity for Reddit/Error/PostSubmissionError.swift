//
//  PostSubmissionError.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-14.
//

import Foundation

enum PostSubmissionError: LocalizedError {
    case subredditNotSelectedError
    case noTitleError
    case noURLError
    case galleryImagesNotEnoughError
    case galleryImageUploadError(Int)
    case galleryImageUploadingInProgress
    
    var errorDescription: String? {
        switch self {
        case .subredditNotSelectedError:
            return "Please select a subreddit first."
        case .noTitleError:
            return "Title is required."
        case .noURLError:
            return "URL is required."
        case .galleryImagesNotEnoughError:
            return "At least two images are required."
        case .galleryImageUploadError(let index):
            return "Image #\(index + 1) failed to upload. Please tap that image to retry."
        case .galleryImageUploadingInProgress:
            return "Images are still uploading. Please wait."
        }
    }
}
