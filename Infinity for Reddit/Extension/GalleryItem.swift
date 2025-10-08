//
//  GalleryItem.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-07.
//

extension GalleryItem {
    func toDownloadMediaType(post: Post?) -> DownloadMediaType {
        switch mediaType {
        case .image:
            return .image(downloadUrlString: urlString, fileName: "\(post == nil ? "Gallery-" : post!.fileNameWithoutExtension + "-")\(mediaId ?? Utils.randomString()).\(Utils.getFileExtension(from: urlString) ?? "jpg")")
        case .gif:
            return .gif(downloadUrlString: urlString, fileName: "\(post == nil ? "Gallery-" : post!.fileNameWithoutExtension + "-")\(mediaId ?? Utils.randomString()).\(Utils.getFileExtension(from: urlString) ?? "gif")")
        case .video:
            return .video(downloadUrlString: urlString, fileName: "\(post == nil ? "Gallery-" : post!.fileNameWithoutExtension + "-")\(mediaId ?? Utils.randomString()).\(Utils.getFileExtension(from: urlString) ?? "mp4")")
        }
    }
}
