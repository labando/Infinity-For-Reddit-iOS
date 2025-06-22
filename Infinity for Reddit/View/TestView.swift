//
//  TestView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI
import AVKit

//struct TestView: View {
//    @EnvironmentObject private var namespaceManager: NamespaceManager
//    @EnvironmentObject var accountViewModel: AccountViewModel
//    
//    @StateObject var manager = DummyManager()
//    
//    var body: some View {
//        ScrollView {
////            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
////                ForEach(manager.visibleDummys) { dummy in
////                    DummyView(dummy: dummy)
////                        .background(GeometryReader { geo in
////                            Color.clear
////                                .preference(key: DummyPositionKey.self, value: [dummy.id: geo.frame(in: .named("scroll")).minY])
////                        })
////                }
////            }
////            .padding()
//            
//            LazyVStack(spacing: 8) {
//                ForEach(manager.visibleDummys) { dummy in
//                    DummyView(dummy: dummy)
//                        .background(GeometryReader { geo in
//                            Color.clear
//                                .preference(key: DummyPositionKey.self, value: [dummy.id: geo.frame(in: .named("scroll")).minY])
//                        })
//                        .id(dummy.id)
//                }
//            }
//            .padding()
//        }
//        .coordinateSpace(name: "scroll")
//        .onAppear {
//            manager.loadInitialDummys()
//        }
//        .onPreferenceChange(DummyPositionKey.self) { values in
//            guard let topItem = values.min(by: { $0.value < $1.value }) else { return }
//            if let topIndex = manager.visibleDummys.firstIndex(where: { $0.id == topItem.key }) {
//                print(topIndex)
//                manager.scrollDidReach(index: topIndex)
//            }
//        }
//    }
//}
//
//struct DummyPositionKey: PreferenceKey {
//    static var defaultValue: [UUID: CGFloat] = [:]
//    static func reduce(value: inout [UUID: CGFloat], nextValue: () -> [UUID: CGFloat]) {
//        value.merge(nextValue(), uniquingKeysWith: { $1 })
//    }
//}
//
//class DummyManager: ObservableObject {
//    @Published var allDummys: [Dummy] = []
//    @Published var visibleDummys: [Dummy] = []
//    
//    private let maxVisibleCount = 30
//    private let step = 10
//    private let preloadMargin = 5
//    
//    // Tracks where the visible window starts
//    private var startIndex = 0
//    
//    func loadInitialDummys() {
//        allDummys = (0..<200).map {
//            Dummy(title: "Dummy \($0)", height: CGFloat.random(in: 120...220))
//        }
//        visibleDummys = Array(allDummys.prefix(maxVisibleCount))
//    }
//    
//    func scrollDidReach(index: Int) {
//        // Determine whether to scroll forward or back
//        if index >= startIndex + maxVisibleCount - preloadMargin {
//            scrollForward()
//        } else if index <= startIndex + preloadMargin {
//            scrollBackward()
//        }
//    }
//    
//    private func scrollForward() {
//            let newStart = min(allDummys.count - maxVisibleCount, startIndex + step)
//            guard newStart > startIndex else { return }
//
//            let end = startIndex + maxVisibleCount
//            let nextEnd = newStart + maxVisibleCount
//
//            // Calculate the overlapping range
//            let preservedRange = max(startIndex + step, newStart)..<min(end, nextEnd)
//
//            // Remove from the beginning
//            visibleDummys.removeFirst(step)
//
//            // Append new posts to the end
//            let itemsToAdd = allDummys[(end)..<min(nextEnd, allDummys.count)]
//            visibleDummys.append(contentsOf: itemsToAdd)
//
//            startIndex = newStart
//        }
//
//        private func scrollBackward() {
//            let newStart = max(0, startIndex - step)
//            guard newStart < startIndex else { return }
//
//            // Calculate range to prepend
//            let itemsToAdd = allDummys[newStart..<startIndex]
//
//            // Remove from the end
//            visibleDummys.removeLast(step)
//
//            // Prepend to the front
//            visibleDummys.insert(contentsOf: itemsToAdd, at: 0)
//
//            startIndex = newStart
//        }
//}
//
//struct DummyView: View {
//    let dummy: Dummy
//    var body: some View {
//        RoundedRectangle(cornerRadius: 8)
//            .fill(Color.blue)
//            .frame(height: dummy.height)
//            .overlay(Text(dummy.title).foregroundColor(.white))
//    }
//}
//
//struct Dummy: Identifiable, Equatable {
//    let id: UUID = UUID()
//    let title: String
//    let height: CGFloat
//}

class PlayerManager : ObservableObject {
    let player = AVPlayer(url: URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!)
    @Published private var playing = false
    
    func play() {
        player.play()
        playing = true
    }
    
    func playPause() {
        if playing {
            player.pause()
        } else {
            player.play()
        }
        playing.toggle()
    }
}

struct TestView: View {
    @StateObject var playerManager = PlayerManager()
    
    var body: some View {
        List {
            VStack(alignment: .center, spacing: 0) {
//                AVPlayerControllerRepresented(player: playerManager.player)
//                    .onAppear {
//                        playerManager.play()
//                    }
//                InlineVideoView(url: URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!)
//                    .frame(height: 300)
                
                
                
                Button("Clear All") {
                    playerManager.playPause()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                
                Text("fuck you ")
            }
            
    //        VideoPlayerContainerView(url: URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!)
    //            .frame(height: 400)
        }
    }
        
}

struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
