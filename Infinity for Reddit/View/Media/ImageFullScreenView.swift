//
//  ImageFullScreenView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-03.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageFullScreenView: View {
    @EnvironmentObject var fullScreenMediaViewModel: FullScreenMediaViewModel
    @EnvironmentObject var namespaceManager: NamespaceManager
    
    let urlString: String
    let aspectRatio: CGSize?
    let matchedGeometryEffectId: String?
    let onDismiss: () -> Void
    
    init(urlString: String, aspectRatio: CGSize? = nil, matchedGeometryEffectId: String? = nil, onDismiss: @escaping () -> Void) {
        self.urlString = urlString
        self.aspectRatio = aspectRatio
        self.matchedGeometryEffectId = matchedGeometryEffectId
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            CustomWebImage(
                urlString,
                aspectRatio: aspectRatio,
                handleImageTapGesture: false,
                matchedGeometryEffectId: matchedGeometryEffectId
            )
            .mediaGesture(
                outOfBoundsColor: .black,
                onDragEnded: { transform in
                    if transform.scaleX == 1 && transform.scaleY == 1 && abs(transform.ty) > 100 {
                        onDismiss()
                        return true
                    }
                    return false
                }
            )
            
            VStack {
                Spacer()
                
                ImageFullScreenToolbar(
                    downloadMediaType: DownloadMediaType.image(downloadUrlString: urlString, fileName: "test.jpg"),
                    onSetAsWallpaper: {
                        print("wallpaper")
                    },
                    onShare: {
                        print("share")
                    }
                )
            }
        }
    }
}
