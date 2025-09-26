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
    @State private var scale: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero
    @State private var currentDragOffset = 0.0
    @State private var hasStartedDragging: Bool = false
    @State private var isAnimatingBack: Bool = false
    @State private var isShowingController: Bool = false
    @State private var isPlaying: Bool = true
    
    let url: URL
    let videoType: VideoType
    let onDismiss: () -> Void
    
    init(url: URL, videoType: VideoType, videoFullScreenViewModel: VideoFullScreenViewModel, onDismiss: @escaping () -> Void) {
        self.url = url
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
        .task {
            await videoFullScreenViewModel.loadAndPlay(url: url, videoType: videoType)
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
    
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        onDismiss()
                    } label: {
                        SwiftUI.Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    if hasAudio {
                        Button {
                            isMuted.toggle()
                        } label: {
                            SwiftUI.Image(systemName: isMuted ? "speaker.slash" : "speaker.wave.2")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(16)
                .transition(.move(edge: .top).combined(with: .opacity))
                
                Spacer()
            }
            .padding(.top, 48)
            
            Button {
                isPlaying.toggle()
            } label: {
                SwiftUI.Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Text(formatTime(currentTime))
                        .foregroundColor(.white)
                        .font(.caption)
                        .frame(width: 50, alignment: .trailing)
                    
                    Slider(value: $currentTime, in: 0...duration, onEditingChanged: { isEditing in
                        isSeekingProgress = isEditing
                    })
                    .padding(.horizontal, 16)
                    
                    Text(formatTime(duration))
                        .foregroundColor(.white)
                        .font(.caption)
                        .frame(width: 50, alignment: .leading)
                }
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
