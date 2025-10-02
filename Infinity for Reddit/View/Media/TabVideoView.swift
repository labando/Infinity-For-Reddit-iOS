//
//  TabVideoView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-02.
//

import SwiftUI

struct TabVideoView: View {
    @StateObject private var videoFullScreenViewModel: VideoFullScreenViewModel
    
    @ObservedObject var tabViewDismissalViewModel: TabViewDismissalViewModel
    
    let urlString: String
    let post: Post?
    let videoType: VideoType
    let isSelected: Bool
    let onDismiss: () -> Void
    
    init(urlString: String,
         post: Post?,
         videoType: VideoType,
         isSelected: Bool,
         tabViewDismissalViewModel: TabViewDismissalViewModel,
         onDismiss: @escaping () -> Void
    ) {
        self.urlString = urlString
        self.post = post
        self.videoType = videoType
        self._videoFullScreenViewModel = StateObject(wrappedValue: .init())
        self.isSelected = isSelected
        self.tabViewDismissalViewModel = tabViewDismissalViewModel
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VideoFullScreenView(
            urlString: urlString,
            post: nil,
            videoType: .direct,
            videoFullScreenViewModel: videoFullScreenViewModel
        ) {
            onDismiss()
        }
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                videoFullScreenViewModel.player.play()
            } else {
                videoFullScreenViewModel.player.pause()
            }
        }
        .onChange(of: tabViewDismissalViewModel.isDismissed) { _, newValue in
            if newValue && !isSelected {
                videoFullScreenViewModel.resetState()
            }
        }
    }
}
