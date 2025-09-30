//
//  VideoFullScreenView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-06.
//

import SwiftUI
import AVKit

struct VideoFullScreenView: View {
    @EnvironmentObject var fullScreenMediaViewModel: FullScreenMediaViewModel
    @EnvironmentObject var namespaceManager: NamespaceManager
    
    @ObservedObject private var videoFullScreenViewModel: VideoFullScreenViewModel
    
    @AppStorage(VideoUserDefaultsUtils.defaultPlaybackSpeedKey, store: .video) private var defaultPlaybackSpeed: Double = 1.0
    
    @State private var scale: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero
    @State private var currentDragOffset = 0.0
    @State private var hasStartedDragging: Bool = false
    @State private var isAnimatingBack: Bool = false
    @State private var isShowingController: Bool = false
    @State private var isPlaying: Bool = true
    @State private var playbackSpeed: Double = 1
    
    let urlString: String
    let post: Post?
    let videoType: VideoType
    let onDismiss: () -> Void
    
    init(urlString: String, post: Post?, videoType: VideoType, videoFullScreenViewModel: VideoFullScreenViewModel, onDismiss: @escaping () -> Void) {
        self.urlString = urlString
        self.post = post
        self.videoType = videoType
        self.videoFullScreenViewModel = videoFullScreenViewModel
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(opacityForBackground())
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
            
            PlayerView(player: videoFullScreenViewModel.player)
                .offset(y: currentDragOffset)
                .onTapGesture {
                    withAnimation {
                        isShowingController.toggle()
                    }
                }
            
            if isShowingController {
                VideoController(
                    isPlaying: $isPlaying,
                    duration: $videoFullScreenViewModel.duration,
                    currentTime: $videoFullScreenViewModel.currentTime,
                    isSeekingProgress: $videoFullScreenViewModel.isSeekingProgress,
                    hasAudio: $videoFullScreenViewModel.hasAudio,
                    isMuted: $videoFullScreenViewModel.isMuted,
                    playbackSpeed: $playbackSpeed,
                    title: post?.title,
                    onFastForward: {
                        let newTime = videoFullScreenViewModel.currentTime + 5
                        videoFullScreenViewModel.player.seek(
                            to: CMTime(seconds: min(videoFullScreenViewModel.duration, newTime), preferredTimescale: 600)
                        )
                    },
                    onRewind: {
                        let newTime = videoFullScreenViewModel.currentTime - 5
                        videoFullScreenViewModel.player.seek(
                            to: CMTime(seconds: min(videoFullScreenViewModel.duration, newTime), preferredTimescale: 600)
                        )
                    },
                    onDownload: {
                        videoFullScreenViewModel.downloadMedia(urlString: urlString, post: post)
                    },
                    onDismiss: {
                        withAnimation {
                            onDismiss()
                        }
                    }
                )
                .onTapGesture {
                    withAnimation {
                        isShowingController.toggle()
                    }
                }
                .zIndex(1)
            }
        }
        .appForegroundBackgroundListener(onAppEntersForeground: {
            //videoFullScreenViewModel.play()
            isPlaying = true
        }, onAppEntersBackground: {
            //videoFullScreenViewModel.pause()
            isPlaying = false
        })
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                videoFullScreenViewModel.play()
            } else {
                videoFullScreenViewModel.pause()
            }
        }
        .onReceive(videoFullScreenViewModel.$currentTime
            .removeDuplicates()
            .throttle(for: .milliseconds(500), scheduler: RunLoop.main, latest: true)
        ) { newValue in
            if videoFullScreenViewModel.isSeekingProgress {
                videoFullScreenViewModel.player.seek(
                    to: CMTime(seconds: newValue, preferredTimescale: 600)
                )
            }
        }
        .onChange(of: videoFullScreenViewModel.isSeekingProgress) { _, newValue in
            if newValue && isPlaying {
                videoFullScreenViewModel.pause()
            } else if !newValue && isPlaying {
                videoFullScreenViewModel.play()
            }
        }
        .onChange(of: videoFullScreenViewModel.isMuted) { _, newValue in
            videoFullScreenViewModel.player.isMuted = newValue
        }
        .onChange(of: playbackSpeed) { _, newValue in
            videoFullScreenViewModel.player.rate = Float(newValue)
        }
        .task {
            await videoFullScreenViewModel.loadAndPlay(urlString: urlString, videoType: videoType)
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    // Only allow vertical drag to trigger dismiss
                    if !hasStartedDragging && abs(value.translation.height) > abs(value.translation.width) {
                        hasStartedDragging = true
                    }
                    if hasStartedDragging {
                        state = value.translation
                    }
                }
                .onChanged { value in
                    // Adjust the scale based on the drag distance
                    currentDragOffset = value.translation.height
                }
                .onEnded { value in
                    if hasStartedDragging && abs(value.translation.height) > 100 {
                        withAnimation(.linear(duration: 0.25)) {
                            isShowingController = false
                            if value.translation.height < 0 {
                                // Dragged up
                                currentDragOffset = -UIScreen.main.bounds.height
                            } else {
                                // Dragged down
                                currentDragOffset = UIScreen.main.bounds.height
                            }
                        } completion: {
                            onDismiss()
                        }
                    } else {
                        withAnimation {
                            currentDragOffset = 0.0
                        }
                    }
                    hasStartedDragging = false
                }
        )
    }
    
    private func opacityForBackground() -> Double {
        let maxOffset: CGFloat = 300
        let offset = min(abs(currentDragOffset), maxOffset)
        return Double(1 - (offset / maxOffset))
    }
}

struct VideoController: View {
    @Binding var isPlaying: Bool
    @Binding var duration: Double
    @Binding var currentTime: Double
    @Binding var isSeekingProgress: Bool
    @Binding var hasAudio: Bool
    @Binding var isMuted: Bool
    @Binding var playbackSpeed: Double
    let title: String?
    
    let onFastForward: () -> Void
    let onRewind: () -> Void
    let onDownload: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 12) {
                    Button {
                        onDismiss()
                    } label: {
                        SwiftUI.Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    if hasAudio {
                        ZStack {
                            SwiftUI.Image(systemName: "speaker.slash")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                                .opacity(isMuted ? 1 : 0)
                            
                            SwiftUI.Image(systemName: "speaker.wave.2")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                                .opacity(isMuted ? 0 : 1)
                        }
                        .onTapGesture {
                            isMuted.toggle()
                        }
                    }
                    
                    Button {
                        onDownload()
                    } label: {
                        SwiftUI.Image(systemName: "arrow.down.square")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                    
                    Menu {
                        Menu {
                            ForEach(Array(VideoUserDefaultsUtils.playbackSpeeds.indices), id: \.self) { index in
                                Button {
                                    playbackSpeed = VideoUserDefaultsUtils.playbackSpeeds[index]
                                } label: {
                                    HStack {
                                        Text(VideoUserDefaultsUtils.playbackSpeedsText[index])
                                            .primaryText()
                                        
                                        Spacer()
                                        
                                        if playbackSpeed == VideoUserDefaultsUtils.playbackSpeeds[index] {
                                            SwiftUI.Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Speed")
                                .primaryText()
                        }
                    } label: {
                        SwiftUI.Image(systemName: "ellipsis.circle")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                }
                .padding(16)
                .transition(.move(edge: .top).combined(with: .opacity))
                
                Spacer()
            }
            .padding(.top, 48)
            
            HStack(spacing: 48) {
                Button {
                    onRewind()
                } label: {
                    SwiftUI.Image(systemName: "backward.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
                
                Button {
                    isPlaying.toggle()
                } label: {
                    SwiftUI.Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.white)
                }
                
                Button {
                    onFastForward()
                } label: {
                    SwiftUI.Image(systemName: "forward.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
            }
            
            VStack {
                Spacer()
                
                if let title {
                    RowText(title)
                        .foregroundStyle(.white)
                        .padding(16)
                }
                
                HStack {
                    Text(formatTime(currentTime))
                        .foregroundStyle(.white)
                    
                    Slider(value: $currentTime, in: 0...duration, onEditingChanged: { isEditing in
                        isSeekingProgress = isEditing
                    })
                    .padding(.horizontal, 16)
                    
                    Text(formatTime(duration))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
    }
    
    private func formatTime(_ seconds: Double) -> String {
        guard !seconds.isNaN else { return "00:00" }
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
