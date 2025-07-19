//
//  TestView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

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

struct DummyListItem: Identifiable {
    let id: Int // The Int itself serves as the unique identifier
    // Add any other dummy properties you might need for your ItemView later
    // var someText: String
    // var imageUrl: URL? // If you plan to use WebImage with it
}

struct TestView: View {
    @State private var items: [DummyListItem] = (0..<5).map { DummyListItem(id: $0) }
    
    var body: some View {
        MultiColumnList(items: items, numberOfColumns: 1, viewForItem: { item, width in
            AnyView(WebImage(url: URL(string: "https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA")) { image in
                image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
            } placeholder: {
                Rectangle().foregroundColor(.gray)
            }
            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            .onSuccess { image, data, cacheType in
                // Success
                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .scaledToFit()
            .aspectRatio(CGSize(width: 1000, height: 523), contentMode: .fit)
            .frame(maxWidth: .infinity)
            //.frame(width:width, height: CGFloat(width) / (CGFloat(1000) / CGFloat(523)), alignment: .leading)
            //                    .onAppear {
            //                        print("fuck you \(width) \(CGFloat(width) / (CGFloat(1000) / CGFloat(523)))")
            //                    }
            
            .background(Color.yellow))
        })
        
//        WaterfallView(
//            items: dummyItems,
//            columns: 1,
//            spacing: 8,
//            itemView: { item in
//                WebImage(url: URL(string: "https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA")) { image in
//                    image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
//                } placeholder: {
//                    Rectangle().foregroundColor(.gray)
//                }
//                // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
//                .onSuccess { image, data, cacheType in
//                    // Success
//                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
//                }
//                .indicator(.activity) // Activity Indicator
//                .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                .scaledToFit()
//                .aspectRatio(CGSize(width: 1000, height: 523), contentMode: .fit)
//                .frame(maxWidth: .infinity)
//                //.frame(width:width, height: CGFloat(width) / (CGFloat(1000) / CGFloat(523)), alignment: .leading)
//                //                    .onAppear {
//                //                        print("fuck you \(width) \(CGFloat(width) / (CGFloat(1000) / CGFloat(523)))")
//                //                    }
//                
//                .background(Color.yellow)
//            },
//            heightForWidth: { item, _ in item.height }
//        )
        
//        MultiColumnList(
//            items: dummyItems,
//            numberOfColumns: 1,
//            viewForItem: { item, width in
//                AnyView(
////                    CustomWebImage(
////                        "https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA",
////                        aspectRatio: CGSize(width: 1000, height: 523),
////                        matchedGeometryEffectId: UUID().uuidString
////                    )
////                    SwiftUI.Image(systemName: "chevron.up")
////                        //.frame(maxWidth: .infinity)
////                        .frame(alignment: .leading)
////                        .background(Color.red)
//                    ZStack {
//                        WebImage(url: URL(string: "https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA")) { image in
//                                image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
//                            } placeholder: {
//                                    Rectangle().foregroundColor(.gray)
//                            }
//                            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
//                            .onSuccess { image, data, cacheType in
//                                // Success
//                                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
//                            }
//                            .indicator(.activity) // Activity Indicator
//                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                            .scaledToFit()
//                            .frame(width:width, height: CGFloat(width) / (CGFloat(1000) / CGFloat(523)), alignment: .leading)
//                            .onAppear {
//                                print("fuck you \(width) \(CGFloat(width) / (CGFloat(1000) / CGFloat(523)))")
//                            }
//                        
//                    }
//                    
//                        .background(Color.yellow)
//                    
////                    GeometryReader { geo in
////                        CustomWebImage(
////                            "https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA",
////                            aspectRatio: CGSize(width: 1000, height: 523),
////                            matchedGeometryEffectId: UUID().uuidString,
////                            placeholderView: {
////                                Spacer()
////                                    .frame(width: geo.size.width, height: CGFloat(geo.size.width) / (CGFloat(1000) / CGFloat(523)))
////                            }
////                        )
////                    }
//                )
//            },
//            onItemAppear: { index, item in
//                
//            }
//        )
        
//        List {
//            CustomWebImage(
//                "https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA",
//                aspectRatio: CGSize(width: 1000, height: 523),
//                matchedGeometryEffectId: UUID().uuidString
//            )
//            
//            CustomWebImage(
//                "https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA",
//                aspectRatio: CGSize(width: 1000, height: 523),
//                matchedGeometryEffectId: UUID().uuidString
//            )
//        }
//        .background(Color.blue)
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
