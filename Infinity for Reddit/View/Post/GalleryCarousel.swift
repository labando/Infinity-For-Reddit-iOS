//
//  GalleryCarousel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-02.
//

import SwiftUI

struct GalleryCarousel: View {
    var items: [GalleryItem]
    var mediaMetadata: [String: MediaMetadata]
    
    init(galleryData: GalleryData, mediaMetadata: [String: MediaMetadata]) {
        self.items = galleryData.items
        self.mediaMetadata = mediaMetadata
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(items, id: \.self) { item in
                    if let media = mediaMetadata[item.mediaId], let preview = media.p.last {
                        CustomWebImage(
                            preview.u,
                            placeholderView: {
                                
                            }
                        )
                    }
                }
            }
        }
    }
}
