//
//  ImgurFullScreenViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-07.
//

import Foundation

class ImgurFullScreenViewModel: ObservableObject {
    @Published var imgurMedia: ImgurMedia?
    @Published var error: Error?
    @Published var isLoading = false
    @Published var isLoaded: Bool = false
    
    let imgurMediaType: ImgurMediaType
    
    init(imgurMediaType: ImgurMediaType) {
        self.imgurMediaType = imgurMediaType
    }
    
    func fetchImgurMedia() async {
        guard !isLoaded && !isLoading else {
            return
        }
        
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let imgurMedia = try await ImgurFetcher.shared.fetchImgurMedia(imgurMediaType: imgurMediaType)
            
            await MainActor.run {
                self.imgurMedia = imgurMedia
                self.isLoaded = true
                self.isLoading = false
            }
        } catch {
            print(error)
            await MainActor.run {
                self.error = error
                self.isLoaded = false
                self.isLoading = false
            }
        }
    }
}
