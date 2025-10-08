//
//  FullScreenMediaType.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-07.
//

extension FullScreenMediaType {
    var getImgurMediaType: ImgurMediaType? {
        switch self {
        case .imgurGallery(let imgurId, _):
            return .imgurGallery(imgurId: imgurId)
        case .imgurAlbum(let imgurId, _):
            return .imgurAlbum(imgurId: imgurId)
        case .imgurImage(let imgurId, _):
            return .imgurImage(imgurId: imgurId)
        default:
            return nil
        }
    }
}
