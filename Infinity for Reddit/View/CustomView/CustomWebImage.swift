//
//  CustomWebImage.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-04-05.
//

import SwiftUI
import Kingfisher

struct CustomWebImage<Placeholder: View, Fallback: View>: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var fullScreenMediaViewModel: FullScreenMediaViewModel
    @EnvironmentObject private var namespaceManager: NamespaceManager

    @State private var shouldLoadFallbackImage = false

    var urlString: String?
    var width: CGFloat?
    var height: CGFloat?
    var imageAspectRatio: CGSize?
    var circleClipped: Bool
    var handleImageTapGesture: Bool
    var centerCrop: Bool
    var matchedGeometryEffectId: String?
    var post: Post?
    var blur: Bool
    
    // Placeholder may be needed in the future.
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
        @ViewBuilder placeholderView: @escaping () -> Placeholder,
        @ViewBuilder fallbackView: @escaping () -> Fallback
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
                fallbackViewBuilder()
                    .applyIf(imageAspectRatio != nil) {
                        $0.aspectRatio(imageAspectRatio!.width / imageAspectRatio!.height, contentMode: centerCrop ? .fill : .fit)
                    }
                    .frame(width: width, height: height)
            } else {
                KFImage(URL(string: urlString!))
                    .resizable()
                    .placeholder { progress in
                        ProgressIndicator()
                    }
                    .onSuccess { result in
                        print("Image loaded from cache: \(result.cacheType)")
                    }
                    .onFailure { error in
                        DispatchQueue.main.async {
                            shouldLoadFallbackImage = true
                        }
                    }
                    .clipShape(circleClipped ? AnyShape(Circle()) : AnyShape(Rectangle()))
                    .applyIf(imageAspectRatio != nil) {
                        $0.aspectRatio(imageAspectRatio!.width / imageAspectRatio!.height, contentMode: centerCrop ? .fill : .fit)
                    }
                    .frame(width: width, height: height)
            }
        }
        .applyIf(handleImageTapGesture) {
            $0.mediaTapGesture(post: post, aspectRatio: imageAspectRatio, matchedGeometryEffectId: matchedGeometryEffectId)
        }
    }
}
