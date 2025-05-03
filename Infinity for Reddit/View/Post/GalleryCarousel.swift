//
//  GalleryCarousel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-02.
//

import SwiftUI

struct GalleryCarousel: View {
    @State private var scrollID: Int?
    
    var items: [GalleryItem]
    var mediaMetadata: [String: MediaMetadata]
    
    init(galleryData: GalleryData, mediaMetadata: [String: MediaMetadata]) {
        self.items = galleryData.items
        self.mediaMetadata = mediaMetadata
    }
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        if let media = mediaMetadata[item.mediaId], let preview = media.p.last {
                            CustomWebImage(
                                preview.u,
                                placeholderView: {
                                    
                                }
                            )
                            .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 0, alignment: .center)
                            .id(index)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            //.contentMargins(0)
            .scrollPosition(id: $scrollID)
            
            Text("\((scrollID ?? 0) + 1)/\(items.count)")
        }
        
    }
}
