//
//  FullScreenMediaViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-04.
//

import Foundation

enum FullScreenMediaType {
    case image(url: String, aspectRatio: CGSize? = nil, post: Post? = nil, matchedGeometryEffectId: String? = nil)
    case gif(url: String, post: Post? = nil)
    case video(url: String, post: Post? = nil, videoType: VideoType? = nil)
    case gallery(currentUrl: String, items: [GalleryItem], mediaMetadata: [String: MediaMetadata], galleryScrollState: GalleryScrollState)
    case imgurGallery(url: URL)
    case imgurAlbum(url: URL)
    case imgurImage(url: URL)
}

enum VideoType {
    case vReddIt
    case redgifs(id: String)
    case streamable(shortCode: String)
}

class GalleryScrollState: ObservableObject {
    @Published var scrollId: Int = 0
    
    init(scrollId: Int) {
        self.scrollId = scrollId
    }
}

class FullScreenMediaViewModel: ObservableObject {
    @Published var media: FullScreenMediaType?
    @Published var matchedGeometryEffectId: String?
    @Published var isTransitioning: Bool = false
    
    func show(_ media: FullScreenMediaType) {
        isTransitioning = true
        self.media = media
        switch media {
        case .image(_, _, _, let matchedGeometryEffectId):
            self.matchedGeometryEffectId = matchedGeometryEffectId
        case .gif:
            break
        case .video:
            break
        case .gallery:
            break
        case .imgurGallery(url: let url):
            break
        case .imgurAlbum(url: let url):
            break
        case .imgurImage(url: let url):
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.isTransitioning = false
        }
    }
    
    func dismiss() {
        isTransitioning = true
        
        self.media = nil
        self.matchedGeometryEffectId = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.isTransitioning = false
        }
    }
}
