//
//  CustomVideoPlayer.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-20.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: View {
    var player: AVPlayer
    
    init(url: URL) {
        player = AVPlayer(url: url)
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .onDisappear {
//                DispatchQueue.main.async {
//                    player.pause()
//                    
//                    NotificationCenter.default.removeObserver(self)
//                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    player.play()
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                           object: player.currentItem,
                                                           queue: .main) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }
                }
            }
            .contentShape(Rectangle())
            .clipped()
    }
}
