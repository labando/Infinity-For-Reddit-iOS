//
//  ImgurMediaItem.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-08.
//

extension ImgurMediaItem {
    func toDownloadMediaType(post: Post?) -> DownloadMediaType {
        switch mediaType {
        case .image:
            return .image(downloadUrlString: link, fileName: "\(post == nil ? "Imgur-" : post!.fileNameWithoutExtension + "-")\(id ?? Utils.randomString()).\(Utils.getFileExtension(from: link) ?? "jpg")")
        case .gif:
            return .image(downloadUrlString: link, fileName: "\(post == nil ? "Imgur-" : post!.fileNameWithoutExtension + "-")\(id ?? Utils.randomString()).\(Utils.getFileExtension(from: link) ?? "gif")")
        case .video:
            return .video(downloadUrlString: link, fileName: "\(post == nil ? "Imgur-" : post!.fileNameWithoutExtension + "-")\(id ?? Utils.randomString()).\(Utils.getFileExtension(from: link) ?? "mp4")")
        }
    }
}
