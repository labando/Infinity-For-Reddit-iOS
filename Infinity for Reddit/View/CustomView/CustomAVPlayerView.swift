//
//  CustomAVPlayerView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-25.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let view = PlayerUIView()
        view.playerLayer.player = player
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // nothing needed, AVPlayer handles playback
    }

    class PlayerUIView: UIView {
        override static var layerClass: AnyClass {
            AVPlayerLayer.self
        }

        var playerLayer: AVPlayerLayer {
            return layer as! AVPlayerLayer
        }
    }
}
