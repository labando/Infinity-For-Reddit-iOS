//
//  ImageFullScreenToolbar.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-24.
//

import SwiftUI

struct ImageFullScreenToolbar: View {
    @StateObject private var fullScreenMediaToolbarViewModel: FullScreenMediaToolbarViewModel
    
    //let onDownload: () -> Void
    let onSetAsWallpaper: () -> Void
    let onShare: () -> Void
    
    private let buttonSize: CGFloat = 24
    
    init(downloadMediaType: DownloadMediaType, onSetAsWallpaper: @escaping () -> Void, onShare: @escaping () -> Void) {
        _fullScreenMediaToolbarViewModel = StateObject(
            wrappedValue: FullScreenMediaToolbarViewModel(downloadMediaType: downloadMediaType)
        )
        self.onSetAsWallpaper = onSetAsWallpaper
        self.onShare = onShare
    }
    
    var body: some View {
        HStack {
            Button {
                fullScreenMediaToolbarViewModel.downloadMedia()
            } label: {
                SwiftUI.Image(systemName: "square.and.arrow.down")
                    .font(.system(size: buttonSize))
                    .padding(.horizontal, 8)
                    .padding(.top, 6)
                    .padding(.bottom, 10)
                    .foregroundColor(Color.white)
                    .background(
                        Circle()
                            .fill(Color(hex: "#08cf75"))
                    )
            }
            
            Button {
                onSetAsWallpaper()
            } label: {
                SwiftUI.Image(systemName: "photo.on.rectangle")
                    .font(.system(size: buttonSize - 4))
                    .padding(12)
                    .foregroundColor(Color.white)
                    .background(
                        Circle()
                            .fill(Color(hex: "#08cf75"))
                    )
            }
            
            Button {
                onShare()
            } label: {
                SwiftUI.Image(systemName: "square.and.arrow.up")
                    .font(.system(size: buttonSize))
                    .padding(.horizontal, 8)
                    .padding(.top, 6)
                    .padding(.bottom, 10)
                    .foregroundColor(Color.white)
                    .background(
                        Circle()
                            .fill(Color(hex: "#08cf75"))
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color(hex: "#b6f2d7", opacity: 0.5))
        )
        .padding(.bottom, 64)
    }
}
