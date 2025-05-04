//
//  FullScreenMediaViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-04.
//

import Foundation

enum FullScreenMediaType: Hashable {
    case image(url: String, post: Post?)
    case gif(url: String, post: Post?)
    case video(url: String, post: Post?)
    case gallery(post: Post?)
}

class FullScreenMediaViewModel: ObservableObject {
    @Published var media: FullScreenMediaType?
    
    var isPresenting: Bool { media != nil }
    
    func show(_ media: FullScreenMediaType) {
        self.media = media
    }
    
    func dismiss() {
        self.media = nil
    }
}
