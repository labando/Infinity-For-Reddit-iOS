//
//  MediaDownloader.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-23.
//

import Alamofire
import Foundation
import UIKit
import Photos

class MediaDownloader {
    enum MediaDownloaderError: Error {
        case invalidURL
        case decodeImageError
        case saveToPhotosLibraryFailed
    }
    
    private let session: Session
    
    private init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self, name: "plain") else {
            fatalError("Failed to resolve plain Session in MediaDownloader")
        }
        self.session = resolvedSession
    }
    
    func download(downloadMediaType: DownloadMediaType) async throws {
        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(downloadMediaType.fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        guard let downloadUrl = await downloadMediaType.getDownloadUrl() else {
            throw MediaDownloaderError.invalidURL
        }
        
        let request = session.download(downloadUrl, to: destination)
        
        Task {
            for await progress in request.downloadProgress() {
                print("Progress: \(progress.fractionCompleted)")
            }
        }
        
        let downloadedFileURL = try await request.serializingDownloadedFileURL().value
        
        switch downloadMediaType {
        case .image:
            try saveImageToPhotosLibrary(downloadedFileURL)
        case .gif:
            try await saveGifToPhotosLibrary(downloadedFileURL)
        case .video:
            try await saveVideoToPhotosLibrary(downloadedFileURL)
        case .gallery:
            // TODO
            break
        case .redgifs:
            try await saveVideoToPhotosLibrary(downloadedFileURL)
        case .streamable:
            try await saveVideoToPhotosLibrary(downloadedFileURL)
        case .imgurVideo:
            try await saveVideoToPhotosLibrary(downloadedFileURL)
        }
    }
    
    private func saveImageToPhotosLibrary(_ downloadedFileURL: URL) throws {
        let data = try Data(contentsOf: downloadedFileURL)
        guard let image = UIImage(data: data) else {
            throw MediaDownloaderError.decodeImageError
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    private func saveGifToPhotosLibrary(_ downloadedFileURL: URL) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: downloadedFileURL)
            }) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: MediaDownloaderError.saveToPhotosLibraryFailed)
                }
            }
        }
    }
    
    private func saveVideoToPhotosLibrary(_ downloadedFileURL: URL) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: downloadedFileURL)
            }) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: MediaDownloaderError.saveToPhotosLibraryFailed)
                }
            }
        }
    }
}

enum DownloadMediaType {
    case image(downloadUrlString: String, fileName: String)
    case gif(downloadUrlString: String, fileName: String)
    case video(downloadUrlString: String, fileName: String)
    case gallery(galleryItems: [GalleryItem], fileName: String)
    case redgifs(redgifsId: String, downloadUrlString: String?)
    case streamable(shortCode: String, downloadUrlString: String?)
    case imgurVideo(downloadUrlString: String, fileName: String)
    
    var fileName: String {
        switch self {
        case .image(_, let fileName):
            return fileName
        case .gif(_, let fileName):
            return fileName
        case .video(_, let fileName):
            return fileName
        case .gallery(_, let fileName):
            return fileName
        case .redgifs(let redgifsId, _):
            return "Redgifs-\(redgifsId).mp4"
        case .streamable(let shortCode, _):
            return "Streamable-\(shortCode).mp4"
        case .imgurVideo(_, let fileName):
            return fileName
        }
    }
    
    func getDownloadUrl() async -> URL? {
        switch self {
        case .image(let downloadUrlString, _):
            return URL(string: downloadUrlString)
        case .gif(let downloadUrlString, _):
            return URL(string: downloadUrlString)
        case .video(let downloadUrlString, _):
            return URL(string: downloadUrlString)
        case .gallery(_, let fileName):
            // Handle gallery media download
            return nil
        case .redgifs(let redgifsId, let downloadUrlString):
            if let downloadUrlString {
                return URL(string: downloadUrlString)
            }
            return try? await VideoFetcher.shared.fetchRedgifsVideo(id: redgifsId)
        case .streamable(let shortCode, let downloadUrlString):
            if let downloadUrlString {
                return URL(string: downloadUrlString)
            }
            return try? await VideoFetcher.shared.fetchStreamableVideo(shortCode: shortCode)
        case .imgurVideo(let downloadUrlString, _):
            // TODO need to check if this is the real download url
            return URL(string: downloadUrlString)
        }
    }
}
