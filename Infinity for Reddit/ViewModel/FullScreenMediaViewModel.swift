//
//  FullScreenMediaViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-04.
//

import Foundation

enum FullScreenMediaType {
    case image(url: String, aspectRatio: CGSize?, post: Post?)
    case gif(url: String, post: Post?)
    case video(url: String, post: Post?)
    case gallery(currentUrl: String, items: [GalleryItem], mediaMetadata: [String: MediaMetadata], galleryScrollState: GalleryScrollState)
}

class GalleryScrollState: ObservableObject {
    @Published var scrollId: Int = 0
    
    init(scrollId: Int) {
        self.scrollId = scrollId
    }
}

class FullScreenMediaViewModel: ObservableObject {
    @Published var media: FullScreenMediaType?
    @Published var currentId: String?
    @Published var isTransitioning: Bool = false
    
    func show(_ media: FullScreenMediaType) {
        isTransitioning = true
        self.media = media
        switch media {
        case .image(let url, _, _):
            self.currentId = url
        case .gif(let url, _):
            self.currentId = url
        case .video(let url, _):
            self.currentId = url
        case .gallery(let currentUrl, _, _, _):
            self.currentId = currentUrl
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.isTransitioning = false
        }
    }
    
    func dismiss() {
        isTransitioning = true
        
        self.media = nil
        self.currentId = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.isTransitioning = false
        }
    }
}
