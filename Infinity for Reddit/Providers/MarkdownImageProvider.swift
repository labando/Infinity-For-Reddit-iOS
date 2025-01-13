//
//  MarkdownImageProvider.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-27.
//

import MarkdownUI
import SDWebImageSwiftUI
import SwiftUI

// MARK: - WebImageProvider

struct WebImageProvider: ImageProvider {
    var mediaMetadata: [String: MediaMetadata]?
    var comment: Comment
    
    init(mediaMetadata: [String: MediaMetadata]?, comment: Comment) {
        self.mediaMetadata = mediaMetadata
        self.comment = comment
    }
    
    func makeImage(url: URL?) -> some View {
        if let unescapedUrl = url?.absoluteString.removingPercentEncoding, let media = mediaMetadata?[unescapedUrl] {
            if media.e == MediaMetadata.gifType {
                WebImage(url: URL(string: media.s.gif ?? ""))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 140)
                    .aspectRatio(CGFloat(media.s.y) / CGFloat(media.s.x), contentMode: .fill)
                    .onTapGesture{
                        if let url = url {
                            handleImageTap(url: url)
                        }
                    }
            } else {
                WebImage(url: URL(string: media.s.u ?? ""))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(CGFloat(media.s.y) / CGFloat(media.s.x), contentMode: .fill)
                    .onTapGesture{
                        if let url = url {
                            handleImageTap(url: url)
                        }
                    }
            }
        } else {
            // When there is no MediaMetadata
            EmptyView()
        }
    }
    
    private func handleImageTap(url: URL) {
        print("Image tapped: \(url)")
    }
}

//extension ImageProvider where Self == WebImageProvider {
//    static var webImage: Self {
//        .init()
//    }
//}

// MARK: - ResizeToFit

/// A layout that resizes its content to fit the container **only** if the content width is greater than the container width.
struct ResizeToFit: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let view = subviews.first else {
            return .zero
        }
        
        var size = view.sizeThatFits(.unspecified)
        
        if size.width != 0 && size.height != 0 {
            let aspectRatio = size.width / size.height
            size.width = proposal.width ?? size.width
            size.height = size.width / aspectRatio
        }
        return size
    }
    
    func placeSubviews(
        in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
    ) {
        guard let view = subviews.first else { return }
        view.place(at: bounds.origin, proposal: .init(bounds.size))
    }
}
