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
    
    var urlString: String?
    var width: CGFloat?
    var height: CGFloat?
    var aspectRatio: CGSize?
    var circleClipped: Bool?
    var placeholderView: (() -> Content)?
    var fallbackView: (() -> Content)?
    
    @State private var shouldLoadFallbackImage = false
    
    init(_ urlString: String?) {
        self.urlString = urlString
    }
    
    init(_ urlString: String?, circleClipped: Bool = false) where Content == EmptyView {
        self.urlString = urlString
        self.circleClipped = circleClipped
    }
    
    init(_ urlString: String?, @ViewBuilder placeholderView: @escaping () -> Content) where Content == EmptyView {
        self.urlString = urlString
        self.placeholderView = placeholderView
    }
    
    init(_ urlString: String?, aspectRatio: CGSize, circleClipped: Bool = false) where Content == EmptyView {
        self.urlString = urlString
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
    }
    
    init(_ urlString: String?, circleClipped: Bool = false, @ViewBuilder fallbackView: @escaping () -> Content) {
        self.urlString = urlString
        self.circleClipped = circleClipped
        self.fallbackView = fallbackView
    }
    
    init(_ urlString: String?, aspectRatio: CGSize, circleClipped: Bool = false, @ViewBuilder placeholderView: @escaping () -> Content) {
        self.urlString = urlString
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.placeholderView = placeholderView
    }
    
    init(_ urlString: String?, width: CGFloat, aspectRatio: CGSize, circleClipped: Bool = false) where Content == EmptyView {
        self.urlString = urlString
        self.width = width
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
    }
    
    init(_ urlString: String?, width: CGFloat, height: CGFloat, circleClipped: Bool = false) where Content == EmptyView {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.circleClipped = circleClipped
    }
    
    init(_ urlString: String?, width: CGFloat, height: CGFloat, circleClipped: Bool = false, @ViewBuilder fallbackView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.circleClipped = circleClipped
        self.fallbackView = fallbackView
    }
    
    init(_ urlString: String?, circleClipped: Bool = false, @ViewBuilder placeholderView: @escaping () -> Content,
         @ViewBuilder fallbackView: @escaping () -> Content) {
        self.urlString = urlString
        self.circleClipped = circleClipped
        self.placeholderView = placeholderView
        self.fallbackView = fallbackView
    }
    
    init(_ urlString: String?, width: CGFloat?, height: CGFloat?, aspectRatio: CGSize?, circleClipped: Bool = false,
         @ViewBuilder placeholderView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
        self.placeholderView = placeholderView
    }
    
    init(_ urlString: String?, width: CGFloat?, height: CGFloat?, aspectRatio: CGSize?, circleClipped: Bool = false,
         @ViewBuilder placeholderView: @escaping () -> Content,
         @ViewBuilder fallbackView: @escaping () -> Content) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.circleClipped = circleClipped
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
        .contentShape(Rectangle())
        .highPriorityGesture(
            TapGesture()
                .onEnded {
                    print("urlString: \(urlString ?? "nil")")
                    if let urlString = urlString {
                        navigationManager.path.append(MediaNavigation.image(url: urlString, post: nil))
                    }
                }
        )
    }
}
