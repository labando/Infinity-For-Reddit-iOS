//
// SubmitGalleryPostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-10-04
        
import Foundation
import UIKit
import PhotosUI

@MainActor
class SubmitGalleryPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var galleryImages: [UploadedImage] = []
    
    let mediaUploadRepository: MediaUploadRepository
    
    init(mediaUploadRepository: MediaUploadRepository) {
        self.selectedAccount = AccountViewModel.shared.account
        self.mediaUploadRepository = mediaUploadRepository
    }
    
    func addImage(_ image: UIImage) {
        if galleryImages.count < 20 {
            let galleryImage = UploadedImage(image: image) {
                try await self.mediaUploadRepository.uploadImage(account: self.selectedAccount, image: image, getImageId: true)
            }
            galleryImage.upload()
            galleryImages.append(galleryImage)
        }
    }
    
    func clearCapturedImages() {
        for image in galleryImages {
            image.cancelUpload()
        }
        galleryImages.removeAll()
    }
    
    func deleteCapturedImage(at index: Int) {
        guard index >= 0 && index < galleryImages.count else {
            return
        }
        galleryImages[index].cancelUpload()
        galleryImages.remove(at: index)
    }
}
