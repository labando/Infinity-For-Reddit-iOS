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
                    isSeekingProgress: $videoFullScreenViewModel.isSeekingProgress
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
        .onChange(of: videoFullScreenViewModel.currentTime) { _, newValue in
            if videoFullScreenViewModel.isSeekingProgress {
                self.videoFullScreenViewModel.player.seek(to: CMTime(seconds: videoFullScreenViewModel.currentTime, preferredTimescale: 600))
            }
        }
        .onChange(of: videoFullScreenViewModel.isSeekingProgress) { _, newValue in
            if newValue && isPlaying {
                videoFullScreenViewModel.pause()
            } else if !newValue && isPlaying {
                videoFullScreenViewModel.play()
            }
            //self.isPlaying = !newValue
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
    
    var body: some View {
        ZStack {
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
                    Slider(value: $currentTime, in: 0...duration, onEditingChanged: { isEditing in
                        isSeekingProgress = isEditing
                    })
                    .padding(.horizontal, 32)
                }
            }
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
    }
}
