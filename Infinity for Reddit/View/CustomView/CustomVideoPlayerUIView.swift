//
//  CustomVideoPlayerUIView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-20.
//

import AVKit
import SwiftUI

class VideoPlayerUIView: UIView {
    private let player: AVPlayer
    private let playerLayer = AVPlayerLayer()
    private let videoPos: Binding<Double>
    private let videoDuration: Binding<Double>
    private let seeking: Binding<Bool>
    private var durationObservation: NSKeyValueObservation?
    private var timeObservation: Any?
  
    init(player: AVPlayer, videoPos: Binding<Double>, videoDuration: Binding<Double>, seeking: Binding<Bool>) {
        self.player = player
        self.videoDuration = videoDuration
        self.videoPos = videoPos
        self.seeking = seeking
        
        super.init(frame: .zero)
    
        backgroundColor = .lightGray
        playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        // Observe the duration of the player's item so we can display it
        // and use it for updating the seek bar's position
        durationObservation = player.currentItem?.observe(\.duration, changeHandler: { [weak self] item, change in
            guard let self = self else { return }
            self.videoDuration.wrappedValue = item.duration.seconds
        })
        
        // Observe the player's time periodically so we can update the seek bar's
        // position as we progress through playback
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // If we're not seeking currently (don't want to override the slider
            // position if the user is interacting)
            guard !self.seeking.wrappedValue else {
                return
            }
        
            // update videoPos with the new video time (as a percentage)
            self.videoPos.wrappedValue = time.seconds / self.videoDuration.wrappedValue
        }
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
    
        playerLayer.frame = bounds
    }
    
    func cleanUp() {
        // Remove observers we setup in init
        durationObservation?.invalidate()
        durationObservation = nil
        
        if let observation = timeObservation {
            player.removeTimeObserver(observation)
            timeObservation = nil
        }
    }
  
}

// This is the SwiftUI view which wraps the UIKit-based PlayerUIView above
struct VideoPlayerView: UIViewRepresentable {
    @Binding private(set) var videoPos: Double
    @Binding private(set) var videoDuration: Double
    @Binding private(set) var seeking: Bool
    
    let player: AVPlayer
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoPlayerView>) {
        // This function gets called if the bindings change, which could be useful if
        // you need to respond to external changes, but we don't in this example
    }
    
    func makeUIView(context: UIViewRepresentableContext<VideoPlayerView>) -> UIView {
        let uiView = VideoPlayerUIView(player: player,
                                       videoPos: $videoPos,
                                       videoDuration: $videoDuration,
                                       seeking: $seeking)
        return uiView
    }
    
    static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
        guard let playerUIView = uiView as? VideoPlayerUIView else {
            return
        }
        
        playerUIView.cleanUp()
    }
}

// This is the SwiftUI view that contains the controls for the player
struct VideoPlayerControlsView : View {
    @Binding private(set) var videoPos: Double
    @Binding private(set) var videoDuration: Double
    @Binding private(set) var seeking: Bool
    
    let player: AVPlayer
    
    @State private var playerPaused = true
    
    var body: some View {
        HStack {
            // Play/pause button
            Button(action: togglePlayPause) {
                SwiftUI.Image(systemName: playerPaused ? "play" : "pause")
                    .padding(.trailing, 10)
            }
            // Current video time
            Text("\(Utility.formatSecondsToHMS(videoPos * videoDuration))")
            // Slider for seeking / showing video progress
            Slider(value: $videoPos, in: 0...1, onEditingChanged: sliderEditingChanged)
            // Video duration
            Text("\(Utility.formatSecondsToHMS(videoDuration))")
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    
    private func togglePlayPause() {
        print("togglePlayPause" + String(playerPaused))
        pausePlayer(!playerPaused)
    }
    
    private func pausePlayer(_ pause: Bool) {
        playerPaused = pause
        if playerPaused {
            print("pause")
            player.pause()
        }
        else {
            print("play")
            player.play()
        }
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Set a flag stating that we're seeking so the slider doesn't
            // get updated by the periodic time observer on the player
            print("sliderEditingChanged " + String(editingStarted))
            seeking = true
            pausePlayer(true)
        }
        
        // Do the seek if we're finished
        if !editingStarted {
            let targetTime = CMTime(seconds: videoPos * videoDuration,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the seek is finished, resume normal operation
                self.seeking = false
                self.pausePlayer(false)
            }
        }
    }
}

//struct VideoPlayerControlsView : View {
//    @Binding private(set) var videoPos: Double
//    @Binding private(set) var videoDuration: Double
//    @Binding private(set) var seeking: Bool
//    
//    let player: AVPlayer
//    
//    @State private var playerPaused = true
//    @State private var timeControlObserver: NSKeyValueObservation?
//
//    var body: some View {
//        HStack {
//            Button(action: togglePlayPause) {
//                SwiftUI.Image(systemName: playerPaused ? "play" : "pause")
//                    .padding(.trailing, 10)
//            }
//
//            Text("\(Utility.formatSecondsToHMS(videoPos * videoDuration))")
//
//            Slider(value: $videoPos, in: 0...1, onEditingChanged: sliderEditingChanged)
//
//            Text("\(Utility.formatSecondsToHMS(videoDuration))")
//        }
//        .padding(.horizontal, 10)
//        .onAppear {
//            observePlayerState()
//        }
//        .onDisappear {
//            timeControlObserver?.invalidate()
//        }
//    }
//
//    private func observePlayerState() {
//        timeControlObserver = player.observe(\.timeControlStatus, options: [.new, .initial]) { _, change in
//            DispatchQueue.main.async {
//                self.playerPaused = (player.timeControlStatus != .playing)
//            }
//        }
//    }
//
//    private func togglePlayPause() {
//        if playerPaused {
//            player.play()
//        } else {
//            player.pause()
//        }
//    }
//
//    private func sliderEditingChanged(editingStarted: Bool) {
//        if editingStarted {
//            seeking = true
//            player.pause()
//        } else {
//            let targetTime = CMTime(seconds: videoPos * videoDuration,
//                                    preferredTimescale: 600)
//            player.seek(to: targetTime) { _ in
//                seeking = false
//                player.play()
//            }
//        }
//    }
//}

// This is the SwiftUI view which contains the player and its controls
struct VideoPlayerContainerView : View {
    // The progress through the video, as a percentage (from 0 to 1)
    @State private var videoPos: Double = 0
    // The duration of the video in seconds
    @State private var videoDuration: Double = 0
    // Whether we're currently interacting with the seek bar or doing a seek
    @State private var seeking = false
    
    private let player: AVPlayer
  
    init(url: URL) {
        player = AVPlayer(url: url)
        player.play()
    }
  
    var body: some View {
        VStack {
            VideoPlayerView(videoPos: $videoPos,
                            videoDuration: $videoDuration,
                            seeking: $seeking,
                            player: player)
            
            VideoPlayerControlsView(videoPos: $videoPos,
                                    videoDuration: $videoDuration,
                                    seeking: $seeking,
                                    player: player)
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
}

class Utility: NSObject {
    
    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    static func formatSecondsToHMS(_ seconds: Double) -> String {
        guard !seconds.isNaN,
            let text = timeHMSFormatter.string(from: seconds) else {
                return "00:00"
        }
         
        return text
    }
    
}
