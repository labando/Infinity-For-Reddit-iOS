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
    case imageNotSelectedError
    case gifDataError
    case videoDataError
    case videoThumbnailError
    case videoLoadingError
    case videoStillBeingProcessedError
    case videoNotSelectedError
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
        case .imageNotSelectedError:
            return "Please select an image first."
        case .gifDataError:
            return "Cannot get GIF data. Please try selecting a different one."
        case .videoDataError:
            return "Cannot get video data. Please try selecting a different one."
        case .videoThumbnailError:
            return "Cannot generate video thumbnail. Please try selecting a different video."
        case .videoLoadingError:
            return "Can't load video. Please try selecting a different one."
        case .videoStillBeingProcessedError:
            return "The video is currently being processed. Please wait a moment before submitting."
        case .videoNotSelectedError:
            return "Please select an image first."
        case .galleryImagesNotEnoughError:
            return "At least two images are required."
        case .galleryImageUploadError(let index):
            return "Image #\(index + 1) failed to upload. Please tap that image to retry."
        case .galleryImageUploadingInProgress:
            return "Images are still uploading. Please wait."
        }
    }
}
