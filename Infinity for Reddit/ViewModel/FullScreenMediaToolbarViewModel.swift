//
//  FullScreenMediaToolbarViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-24.
//

import Foundation

class FullScreenMediaToolbarViewModel: ObservableObject {
    @Published var downloadProgress: Double = 0
    @Published var error: Error?
    
    private let downloadMediaType: DownloadMediaType
    private var downloadTask: Task<Void, Never>?
    
    init(downloadMediaType: DownloadMediaType) {
        self.downloadMediaType = downloadMediaType
    }

    func downloadMedia() {
        guard downloadTask == nil else {
            return
        }
        
        downloadTask = Task {
            await self.downloadMediaAsync()
        }
    }
    
    private func downloadMediaAsync() async {
        do {
            try await MediaDownloader.shared.download(downloadMediaType: downloadMediaType, onProgress: { progress in
                await MainActor.run {
                    self.downloadProgress = progress
                }
            })
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
        await MainActor.run {
            self.downloadProgress = 0
            self.downloadTask = nil
        }
    }
}
