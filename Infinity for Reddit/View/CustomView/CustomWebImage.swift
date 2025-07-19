//
//  CustomWebImage.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-04-05.
//

import SwiftUI
import SDWebImageSwiftUI

//struct CustomWebImage<Content: View>: View {
//    @EnvironmentObject var navigationManager: NavigationManager
//    @EnvironmentObject var fullScreenMediaViewModel: FullScreenMediaViewModel
//    @EnvironmentObject private var namespaceManager: NamespaceManager
//    
//    @State private var shouldLoadFallbackImage = false
//    
//    var urlString: String?
//    var width: CGFloat?
//    var height: CGFloat?
//    var aspectRatio: CGSize?
//    var circleClipped: Bool?
//    var handleImageTapGesture: Bool
//    var centerCrop: Bool
//    var matchedGeometryEffectId: String?
//    var post: Post?
//    var blur: Bool
//    var placeholderView: (() -> Content)?
//    var fallbackView: (() -> Content)?
//    
//    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil, blur: Bool = false) where Content == EmptyView {
//        self.urlString = urlString
//        self.width = width
//        self.height = height
//        self.aspectRatio = aspectRatio
//        self.circleClipped = circleClipped
//        self.centerCrop = centerCrop
//        self.handleImageTapGesture = handleImageTapGesture
//        self.matchedGeometryEffectId = matchedGeometryEffectId
//        self.post = post
//        self.blur = blur
//        print("fuck")
//        if width != nil {
//            print(width)
//        }
//    }
//    
//
//    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil, blur: Bool = false,
//         @ViewBuilder placeholderView: @escaping () -> Content) {
//        self.urlString = urlString
//        self.width = width
//        self.height = height
//        self.aspectRatio = aspectRatio
//        self.circleClipped = circleClipped
//        self.centerCrop = centerCrop
//        self.handleImageTapGesture = handleImageTapGesture
//        self.matchedGeometryEffectId = matchedGeometryEffectId
//        self.post = post
//        self.blur = blur
//        self.placeholderView = placeholderView
//        if width != nil {
//            print(width)
//        }
//    }
//    
//    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil, blur: Bool = false,
//         @ViewBuilder fallbackView: @escaping () -> Content) {
//        self.urlString = urlString
//        self.width = width
//        self.height = height
//        self.aspectRatio = aspectRatio
//        self.circleClipped = circleClipped
//        self.centerCrop = centerCrop
//        self.handleImageTapGesture = handleImageTapGesture
//        self.matchedGeometryEffectId = matchedGeometryEffectId
//        self.post = post
//        self.blur = blur
//        self.fallbackView = fallbackView
//        if width != nil {
//            print(width)
//        }
//    }
//    
//    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil, blur: Bool = false,
//         @ViewBuilder placeholderView: @escaping () -> Content,
//         @ViewBuilder fallbackView: @escaping () -> Content) {
//        self.urlString = urlString
//        self.width = width
//        self.height = height
//        self.aspectRatio = aspectRatio
//        self.circleClipped = circleClipped
//        self.handleImageTapGesture = handleImageTapGesture
//        self.matchedGeometryEffectId = matchedGeometryEffectId
//        self.post = post
//        self.blur = blur
//        self.centerCrop = centerCrop
//        self.placeholderView = placeholderView
//        self.fallbackView = fallbackView
//        if width != nil {
//            print(width)
//        }
//    }
//    
//    var body: some View {
//        ZStack {
//            if shouldLoadFallbackImage || urlString == nil {
//                if let fallbackView = fallbackView {
//                    fallbackView()
//                }
//            } else {
////                if false {
////                //if handleImageTapGesture == true && matchedGeometryEffectId != nil && fullScreenMediaViewModel.matchedGeometryEffectId == matchedGeometryEffectId {
////                    // Image is now in full screen mode
////                    Color.clear
////                        .frame(width: width)
////                        .frame(height: height)
////                } else {
//                    WebImage(url: URL(string: urlString!)) { image in
//                        if let aspectRatio = aspectRatio {
//                            image
//                                .resizable()
//                                .aspectRatio(aspectRatio, contentMode: .fit)
//                        } else {
//                            image
//                                .resizable()
//                        }
//                    } placeholder: {
//                        placeholderView?()
//                    }
//                    .onSuccess { image, data, cacheType in
//                        // Success
//                        // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
//                    }
//                    .onFailure { _ in
//                        if fallbackView != nil {
//                            DispatchQueue.main.async {
//                                shouldLoadFallbackImage = true
//                            }
//                        }
//                    }
//                    .indicator(.activity)
//                    .clipShape(circleClipped == true ? AnyShape(Circle()) : AnyShape(Rectangle()))
//                    .transition(.fade(duration: 0.5))
////                    .frame(width: width)
////                    .frame(height: height)
//                    .applyIf(centerCrop == true) {
//                        $0.scaledToFill()
//                            .clipped()
//                    }
//                    .applyIf(centerCrop == false) {
//                        $0.scaledToFit()
//                    }
////                    .applyIf(matchedGeometryEffectId != nil) {
////                        $0.matchedGeometryEffect(id: matchedGeometryEffectId!, in: namespaceManager.animation)
////                    }
//                    .applyIf(blur) {
//                        $0.blur(radius: 20)
//                    }
//                    //.id(matchedGeometryEffectId)
//                //}
//            }
//        }
//        .applyIf(handleImageTapGesture == true) {
//            $0.mediaTapGesture(post: post, aspectRatio: aspectRatio, matchedGeometryEffectId: matchedGeometryEffectId)
//        }
//    }
//}

struct CustomWebImage<Placeholder: View, Fallback: View>: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var fullScreenMediaViewModel: FullScreenMediaViewModel
    @EnvironmentObject private var namespaceManager: NamespaceManager

    @State private var shouldLoadFallbackImage = false

    var urlString: String?
    var width: CGFloat?
    var height: CGFloat?
    var imageAspectRatio: CGSize? // Renamed to avoid clash with aspectRatio modifier
    var circleClipped: Bool
    var handleImageTapGesture: Bool
    var centerCrop: Bool
    var matchedGeometryEffectId: String?
    var post: Post?
    var blur: Bool
    
    // Store the ViewBuilder closures directly as properties
    // These must be non-optional because the initializers will provide a default EmptyView if not specified
    private let placeholderViewBuilder: () -> Placeholder
    private let fallbackViewBuilder: () -> Fallback

    // MARK: - Initializers

    // Primary Initializer: All parameters explicit, with default @ViewBuilder closures
    init(
        _ urlString: String? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        aspectRatio: CGSize? = nil,
        circleClipped: Bool = false,
        handleImageTapGesture: Bool = true,
        centerCrop: Bool = false,
        matchedGeometryEffectId: String? = nil,
        post: Post? = nil,
        blur: Bool = false,
        @ViewBuilder placeholderView: @escaping () -> Placeholder, // NOT OPTIONAL HERE
        @ViewBuilder fallbackView: @escaping () -> Fallback // NOT OPTIONAL HERE
    ) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.imageAspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.handleImageTapGesture = handleImageTapGesture
        self.centerCrop = centerCrop
        self.matchedGeometryEffectId = matchedGeometryEffectId
        self.post = post
        self.blur = blur
        self.placeholderViewBuilder = placeholderView // Assign the closures
        self.fallbackViewBuilder = fallbackView     // Assign the closures
        
        if let receivedWidth = width { print("CustomWebImage init: Received width = \(receivedWidth)") }
        if let receivedHeight = height { print("CustomWebImage init: Received height = \(receivedHeight)") }
    }

    // Convenience Initializer: No custom placeholder or fallback (both become EmptyView)
    // This initializer is for when you call `CustomWebImage(...)` without trailing closures.
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil, blur: Bool = false) where Placeholder == EmptyView, Fallback == EmptyView {
        // Call the primary initializer, providing EmptyView for the closures
        self.init(urlString, width: width, height: height, aspectRatio: aspectRatio, circleClipped: circleClipped, handleImageTapGesture: handleImageTapGesture, centerCrop: centerCrop, matchedGeometryEffectId: matchedGeometryEffectId, post: post, blur: blur,
                  placeholderView: { EmptyView() }, // Explicitly provide EmptyView
                  fallbackView: { EmptyView() })   // Explicitly provide EmptyView
    }

    // Convenience Initializer: Only custom placeholder (Fallback becomes EmptyView)
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil, blur: Bool = false,
         @ViewBuilder placeholderView: @escaping () -> Placeholder) where Fallback == EmptyView {
        self.init(urlString, width: width, height: height, aspectRatio: aspectRatio, circleClipped: circleClipped, handleImageTapGesture: handleImageTapGesture, centerCrop: centerCrop, matchedGeometryEffectId: matchedGeometryEffectId, post: post, blur: blur,
                  placeholderView: placeholderView,
                  fallbackView: { EmptyView() }) // Explicitly provide EmptyView for fallback
    }
    
    // Convenience Initializer: Only custom fallback (Placeholder becomes EmptyView)
    init(_ urlString: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil, aspectRatio: CGSize? = nil, circleClipped: Bool = false, handleImageTapGesture: Bool = true, centerCrop: Bool = false, matchedGeometryEffectId: String? = nil, post: Post? = nil, blur: Bool = false,
         @ViewBuilder fallbackView: @escaping () -> Fallback) where Placeholder == EmptyView {
        self.init(urlString, width: width, height: height, aspectRatio: aspectRatio, circleClipped: circleClipped, handleImageTapGesture: handleImageTapGesture, centerCrop: centerCrop, matchedGeometryEffectId: matchedGeometryEffectId, post: post, blur: blur,
                  placeholderView: { EmptyView() }, // Explicitly provide EmptyView for placeholder
                  fallbackView: fallbackView)
    }

    // MARK: - Body Implementation

    var body: some View {
        ZStack {
            if shouldLoadFallbackImage || urlString == nil {
                fallbackViewBuilder() // Call the non-optional fallback builder
            } else {
                WebImage(url: URL(string: urlString!)) { image in
                    image
                        .resizable()
                        //.indicator(.activity)
                        //.clipShape(circleClipped ? AnyShape(Circle()) : AnyShape(Rectangle()))
                        .transition(.fade(duration: 0.5))
                        .applyIf(blur) { $0.blur(radius: 20) }
                        .applyIf(centerCrop) {
                            $0.scaledToFill().clipped()
                        }
                        .applyIf(!centerCrop) {
                            $0.scaledToFit()
                        }
                        .applyIf(imageAspectRatio != nil) {
                            $0.aspectRatio(imageAspectRatio!.width / imageAspectRatio!.height, contentMode: centerCrop ? .fill : .fit)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .frame(width: width, height: height) // CRITICAL: Frame applied here!
                        // Removed matchedGeometryEffectId application from here; re-evaluate its placement
                        // based on your animation needs if it's causing issues. Usually applied to the ZStack.
                } placeholder: {
                    placeholderViewBuilder() // Call the non-optional placeholder builder
                }
                .onSuccess { image, data, cacheType in
                    // ...
                }
                .onFailure { _ in
                    DispatchQueue.main.async {
                        shouldLoadFallbackImage = true
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(width: width, height: height) // CRITICAL: Frame applied here!
            }
        }
        .applyIf(handleImageTapGesture) {
            $0.mediaTapGesture(post: post, aspectRatio: imageAspectRatio, matchedGeometryEffectId: matchedGeometryEffectId)
        }
        // If matchedGeometryEffectId applies to the whole CustomWebImage, place it here:
//        .applyIf(matchedGeometryEffectId != nil && namespaceManager.animation != nil) {
//            $0.matchedGeometryEffect(id: matchedGeometryEffectId!, in: namespaceManager.animation!)
//        }
    }
}
