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
    @EnvironmentObject private var namespaceManager: NamespaceManager
    
    @State private var shouldLoadFallbackImage = false
    
    var urlString: String?
    var width: CGFloat?
    var height: CGFloat?
    var aspectRatio: CGSize?
    var circleClipped: Bool?
    var handleImageTapGesture: Bool
    var centerCrop: Bool
    var matchedGeometryEffectId: String?
    var post: Post?
    var placeholderView: (() -> Content)?
    var fallbackView: (() -> Content)?
    
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil) where Content == EmptyView {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.centerCrop = centerCrop
        self.handleImageTapGesture = handleImageTapGesture
        self.matchedGeometryEffectId = matchedGeometryEffectId
        self.post = post
    }
    

    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil,
         @ViewBuilder placeholderView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.centerCrop = centerCrop
        self.handleImageTapGesture = handleImageTapGesture
        self.matchedGeometryEffectId = matchedGeometryEffectId
        self.post = post
        self.placeholderView = placeholderView
    }
    
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil,
         @ViewBuilder fallbackView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.centerCrop = centerCrop
        self.handleImageTapGesture = handleImageTapGesture
        self.matchedGeometryEffectId = matchedGeometryEffectId
        self.post = post
        self.fallbackView = fallbackView
    }
    
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil,
         @ViewBuilder placeholderView: @escaping () -> Content,
         @ViewBuilder fallbackView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.handleImageTapGesture = handleImageTapGesture
        self.matchedGeometryEffectId = matchedGeometryEffectId
        self.post = post
        self.centerCrop = centerCrop
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
                if handleImageTapGesture == true && matchedGeometryEffectId != nil && fullScreenMediaViewModel.matchedGeometryEffectId == matchedGeometryEffectId {
                    // Image is now in full screen mode
                    Color.clear
                        .frame(width: width)
                        .frame(height: height)
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
                    .clipShape(circleClipped == true ? AnyShape(Circle()) : AnyShape(Rectangle()))
                    .transition(.fade(duration: 0.5))
                    .frame(width: width)
                    .frame(height: height)
                    .applyIf(centerCrop == true) {
                        $0.scaledToFill()
                            .clipped()
                    }
                    .applyIf(centerCrop == false) {
                        $0.scaledToFit()
                    }
                    .applyIf(matchedGeometryEffectId != nil) {
                        $0.matchedGeometryEffect(id: matchedGeometryEffectId!, in: namespaceManager.animation)
                    }
                    .id(matchedGeometryEffectId)
                }
            }
        }
        .applyIf(handleImageTapGesture == true) {
            $0.mediaTapGesture(post: post, aspectRatio: aspectRatio, matchedGeometryEffectId: matchedGeometryEffectId)
        }
    }
}
