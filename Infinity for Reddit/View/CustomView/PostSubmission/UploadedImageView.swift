//
//  UploadedImageView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-18.
//

import SwiftUI

struct UploadedImageView: View {
    @ObservedObject var uploadedImage: UploadedImage

    var width: CGFloat?
    var height: CGFloat?
    var centerCrop: Bool = false
    var onImageTapped: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            SwiftUI.Image(uiImage: uploadedImage.image)
                .resizable()
                .applyIf(centerCrop) {
                    $0.scaledToFill()
                        .clipped()
                }
                .applyIf(!centerCrop) {
                    $0.scaledToFit()
                }
                .applyIf(width != nil) {
                    $0.frame(width: width!)
                }
                .applyIf(height != nil) {
                    $0.frame(height: height!)
                }
                .cornerRadius(8)
            
            if uploadedImage.isUploading {
                ProgressIndicator()
            } else if !uploadedImage.isUploaded && uploadedImage.uploadError != nil {
                SwiftUI.Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white)
            }
        }
        .onTapGesture {
            if uploadedImage.isUploaded {
                onImageTapped?()
            } else if uploadedImage.uploadError != nil {
                uploadedImage.upload()
            }
        }
    }
}
