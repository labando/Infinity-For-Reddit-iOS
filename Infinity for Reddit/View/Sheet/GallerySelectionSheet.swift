//
// GallerySelectionSheet.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-10-13

import SwiftUI

public struct GallerySelectionSheet: View {
    public var onCameraTap: () -> Void
    public var onPhotoPickerTap: () -> Void
    
    public init(
        onCameraTap: @escaping () -> Void,
        onPhotoPickerTap: @escaping () -> Void
    ) {
        self.onCameraTap = onCameraTap
        self.onPhotoPickerTap = onPhotoPickerTap
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SimpleTouchItemRow(
                    text: "Select an Image",
                    icon: "photo.fill.on.rectangle.fill",
                    action: onPhotoPickerTap
                )
                
                SimpleTouchItemRow(
                    text: "Capture",
                    icon: "camera.fill",
                    action: onCameraTap
                )
            }
            .padding(.top, 20)
        }
    }
}
