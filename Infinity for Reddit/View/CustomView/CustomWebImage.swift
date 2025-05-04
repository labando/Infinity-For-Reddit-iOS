//
//  CustomWebImage.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-04-05.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomWebImage<Content: View>: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var fullScreenMediaViewModel: FullScreenMediaViewModel
    
    @State private var shouldLoadFallbackImage = false
    
    var urlString: String?
    var width: CGFloat?
    var height: CGFloat?
    var aspectRatio: CGSize?
    var circleClipped: Bool?
    var handleImageTapGesture: Bool
    var placeholderView: (() -> Content)?
    var fallbackView: (() -> Content)?
    
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true) where Content == EmptyView {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.handleImageTapGesture = handleImageTapGesture
    }
    
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true,
         @ViewBuilder placeholderView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.handleImageTapGesture = handleImageTapGesture
        self.placeholderView = placeholderView
    }
    
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true,
         @ViewBuilder fallbackView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.handleImageTapGesture = handleImageTapGesture
        self.fallbackView = fallbackView
    }
    
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true,
         @ViewBuilder placeholderView: @escaping () -> Content,
         @ViewBuilder fallbackView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.handleImageTapGesture = handleImageTapGesture
        self.placeholderView = placeholderView
        self.fallbackView = fallbackView
    }
    
    var body: some View {
        ZStack {
            if shouldLoadFallbackImage || urlString == nil {
                if let fallbackView = fallbackView {
                    fallbackView()
                }
            } else {
                WebImage(url: URL(string: urlString!)) { image in
                    if let aspectRatio = aspectRatio {
                        image
                            .resizable()
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    } else {
                        image
                            .resizable()
                    }
                } placeholder: {
                    placeholderView?()
                }
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .onFailure { _ in
                    if fallbackView != nil {
                        DispatchQueue.main.async {
                            shouldLoadFallbackImage = true
                        }
                    }
                }
                .indicator(.activity)
                .applyIf(circleClipped == true) {
                    $0.clipShape(Circle())
                }
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .applyIf(width != nil) {
                    $0.frame(width: width!)
                }
                .applyIf(height != nil) {
                    $0.frame(height: height!)
                }
            }
        }
        .applyIf(handleImageTapGesture == true) {
            $0.contentShape(Rectangle())
                .highPriorityGesture(
                    TapGesture()
                        .onEnded {
                            fullScreenMediaViewModel.show(.image(url: urlString ?? "", post: nil))
                        }
                )
        }
    }
}
