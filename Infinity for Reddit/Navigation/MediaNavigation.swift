//
//  MediaNavigation.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-03.
//

enum MediaNavigation: Hashable {
    case image(url: String, post: Post?)
    case gif(url: String, post: Post?)
    case video(url: String, post: Post?)
    case gallery(post: Post?)
}
