//
//  ZoomableScrollView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-06.
//

import SwiftUI

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    var content: Content
    var onSingleTap: () -> Void
    
    // We must use two *local* variables in makeUIView for the initialization fix.
    // We remove the stored properties from the struct to avoid the initialization error.

    init(@ViewBuilder content: () -> Content, onSingleTap: @escaping () -> Void) {
        self.content = content()
        self.onSingleTap = onSingleTap
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.bouncesZoom = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Host SwiftUI content
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostedView)
        
        NSLayoutConstraint.activate([
            hostedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostedView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostedView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            hostedView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        let doubleTap = UITapGestureRecognizer(target: context.coordinator,
                                               action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        let singleTap = UITapGestureRecognizer(target: context.coordinator,
                                               action: #selector(Coordinator.handleSingleTap))
        singleTap.numberOfTapsRequired = 1
        
        // Set the delegate for the single tap to enable coexistence with pan/pinch
        singleTap.delegate = context.coordinator
        scrollView.addGestureRecognizer(singleTap)
        
        // --- 3. THE PRIORITY FIX ---
        // Single tap must wait for the double tap to fail
        singleTap.require(toFail: doubleTap)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController.rootView = content
        context.coordinator.onSingleTap = onSingleTap // Update the tap closure
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content, onSingleTap: onSingleTap)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate, UIGestureRecognizerDelegate {
        var hostingController: UIHostingController<Content>
        var onSingleTap: () -> Void
        
        init(content: Content, onSingleTap: @escaping () -> Void) {
            self.hostingController = UIHostingController(rootView: content)
            self.hostingController.view.backgroundColor = .clear
            self.onSingleTap = onSingleTap
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            hostingController.view
        }
        
        // --- GESTURE DELEGATE METHOD (THE COEXISTENCE FIX) ---
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            // Allows our custom taps to run alongside the UIScrollView's internal pan/pinch gestures.
            return gestureRecognizer is UITapGestureRecognizer
        }
        
        // MARK: - Tap Handlers
        
        @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
            guard let scrollView = recognizer.view as? UIScrollView else { return }
            
            if scrollView.zoomScale == 1.0 {
                // zoom in around tap point
                let pointInView = recognizer.location(in: hostingController.view)
                let newZoomScale: CGFloat = 2
                let scrollViewSize = scrollView.bounds.size
                
                let w = scrollViewSize.width / newZoomScale
                let h = scrollViewSize.height / newZoomScale
                let x = pointInView.x - (w / 2.0)
                let y = pointInView.y - (h / 2.0)
                
                let rectToZoom = CGRect(x: x, y: y, width: w, height: h)
                scrollView.zoom(to: rectToZoom, animated: true)
            } else {
                // zoom out
                scrollView.setZoomScale(1.0, animated: true)
            }
        }
        
        @objc func handleSingleTap() {
            onSingleTap()
        }
    }
}
