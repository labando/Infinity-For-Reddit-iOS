//
//  UploadedImage.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-18.
//

import UIKit

@MainActor
class UploadedImage: ObservableObject {
    let id: UUID = UUID()
    let image: UIImage
    @Published var isUploading: Bool = false
    @Published var isUploaded: Bool = false
    @Published var uploadError: Error?
    var imageId: String?
    let uploadImage: () async throws -> String
    var uploadTask: Task<Void, Never>?
    
    init(image: UIImage, uploadImage: @escaping () async throws -> String) {
        self.image = image
        self.uploadImage = uploadImage
    }
    
    func upload() {
        uploadTask?.cancel()
        
        uploadTask = Task {
            self.isUploading = true
            do {
                //let imageId = try await uploadImage()
                try await Task.sleep(for: .seconds(3))
                let imageId = Utils.randomString()
                self.imageId = imageId
                self.isUploaded = true
                self.isUploading = false
                self.uploadError = nil
            } catch {
                self.isUploaded = false
                self.isUploading = false
                self.uploadError = error
            }
            
            uploadTask = nil
        }
    }
    
    func cancelUpload() {
        uploadTask?.cancel()
        uploadTask = nil
    }
}
