//
//  LinkHandler.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-23.
//

import Foundation
import UIKit

class LinkHandler {
    static let shared = LinkHandler()
    
    private func constructRedditURL(from path: String) -> URL {
        let trimmed = path.trimmingCharacters(in: .whitespacesAndNewlines)
        let full = trimmed.hasPrefix("/") ? "https://www.reddit.com\(trimmed)" : "https://www.reddit.com/\(trimmed)"
        return URL(string: full)!
    }

    func handle(url: URL) {
        let finalURL: URL
        
        if url.scheme == nil && url.host == nil {
            let path = url.absoluteString.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !path.isEmpty else {
                print("invalid link \(url)")
                return
            }
            finalURL = constructRedditURL(from: path)
        } else {
            finalURL = url
        }
        
        guard finalURL.host?.contains("reddit.com") == true else {
            openInSafari(finalURL)
            return
        }

        let path = finalURL.path

        if path.starts(with: "/r/") {
            let parts = path.split(separator: "/")
            if parts.count >= 2 {
                let subreddit = String(parts[1])
                openSubreddit(subreddit)
                return
            }
        }

        if path.contains("/comments/") {
            let parts = path.split(separator: "/")
            if let index = parts.firstIndex(of: "comments"), parts.count > index + 1 {
                let postId = String(parts[index + 1])
                openPost(postId)
                return
            }
        }

        openInSafari(finalURL)
    }

    private func openSubreddit(_ name: String) {
        print("Navigating to subreddit: \(name)")
    }

    private func openPost(_ id: String) {
        print("Navigating to post ID: \(id)")
    }

    private func openInSafari(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
