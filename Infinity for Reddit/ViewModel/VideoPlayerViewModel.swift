//
//  VideoPlayerViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-22.
//

import Foundation
import AVFoundation

class VideoPlayerViewModel: NSObject, ObservableObject {
    let player: AVPlayer
    
    private var statusObserver: NSKeyValueObservation?
    private var timeObserverToken: Any?
    private var timeControlStatusObserver: NSKeyValueObservation?
    
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var isDragging = false
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
        super.init()
        observeCurrentItem()
        observeTime()
        observeTimeControlStatus()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    @objc private func playerDidFinishPlaying() {
        player.seek(to: .zero)
        player.play()
    }
    
    private func observeCurrentItem() {
        player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem", let item = player.currentItem {
            statusObserver = item.observe(\.status, options: [.new]) { [weak self] item, _ in
                guard let self = self else { return }
                if item.status == .readyToPlay {
                    let durationSec = item.duration.seconds
                    if durationSec.isFinite {
                        DispatchQueue.main.async {
                            self.duration = durationSec
                        }
                    }
                }
            }
        }
    }
    
    private func observeTime() {
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if !self.isDragging {
                self.currentTime = time.seconds
            }
        }
    }
    
    private func observeTimeControlStatus() {
        timeControlStatusObserver = player.observe(\.timeControlStatus, options: [.new, .initial]) { [weak self] player, _ in
            DispatchQueue.main.async {
                self?.isPlaying = (player.timeControlStatus == .playing)
            }
        }
    }
    
    func togglePlayPause() {
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        statusObserver?.invalidate()
        timeControlStatusObserver?.invalidate()
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
        }
        player.removeObserver(self, forKeyPath: "currentItem")
    }
}
