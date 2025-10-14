//
//  MediaUploadRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-14.
//

import UIKit

protocol MediaUploadRepositoryProtocol {
    // Returns uploaded image ID
    func uploadImage(account: Account, image: UIImage) async throws -> String
    func uploadGIF(account: Account, gifData: Data) async throws -> String
}
