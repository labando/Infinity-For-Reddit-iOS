//
//  MarkdownUtils.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-28.
//

import Foundation

class MarkdownUtils {
    private static let REGEX_PATTERNS = {
        do {
            return try [
                NSRegularExpression(pattern: #"!?\[gif\]\(([^)]+)\)"#, options: []),
                NSRegularExpression(pattern: #"https:\/\/preview\.redd\.it\/[a-zA-Z0-9]+\.(?:jpeg|jpg|png)\?width=\d+&format=\w+&auto=\w+&s=[a-f0-9]+"#, options: []),
                NSRegularExpression(pattern: #"\[(.*?)\]\(https:\/\/preview\.redd\.it\/[a-zA-Z0-9]+\.(?:jpeg|jpg|png)\?width=\d+&format=\w+&auto=\w+&s=[a-f0-9]+\)"#, options: []),
                NSRegularExpression(pattern: #"\|:?|:?\|"#, options: [])
            ]
        } catch {
            fatalError("Error creating regular expressions: \(error)")
        }
    }()
    
    static func replaceGifURL(_ comment: Comment) -> String {
        guard let commentBody = comment.body else {
            print("Error: Comment body is nil for comment ID: \(comment.id ?? "unknown").")
            return ""
        }
        var replacedBody = commentBody
        
        
        let gifMatches = MarkdownUtils.REGEX_PATTERNS[0].matches(in: commentBody, options: [], range: NSRange(location: 0, length: commentBody.count))
        guard !gifMatches.isEmpty else {
            return commentBody
        }
        
        for match in gifMatches {
            let rangeOfFirstGroup = Range(match.range(at: 1), in: commentBody)!
            let matchedString = String(commentBody[rangeOfFirstGroup])
            //            print("matched \(matchedString)")
            guard let mediaMetadata = comment.mediaMetadata,
                  let mediaData = mediaMetadata[matchedString] as? [String: Any],
                  let sData = mediaData["s"] as? [String: Any],
                  let gifURL = sData["gif"] as? String else {
                continue
            }
            replacedBody = replacedBody.replacingOccurrences(of: matchedString, with: gifURL)
        }
        
        return replacedBody
    }
    
    static func replaceImageURL(_ comment: Comment) -> String {
        guard let commentBody = comment.body else {
            print("Error: Comment body is nil for comment ID: \(comment.id ?? "unknown").")
            return ""
        }
        var replacedBody = commentBody
        
        let imageURLMatches = MarkdownUtils.REGEX_PATTERNS[1].matches(in: commentBody, options: [], range: NSRange(location: 0, length: commentBody.count))
        let imageMarkdownMatches = MarkdownUtils.REGEX_PATTERNS[2].matches(in: commentBody, options: [], range: NSRange(location: 0, length: commentBody.count))
        guard !imageURLMatches.isEmpty || !imageMarkdownMatches.isEmpty else {
            return commentBody
        }
        
        var excludedRanges = Set<NSRange>()
        for match in imageMarkdownMatches {
            if let range = Range(match.range, in: commentBody) {
                let matchedMarkdown = String(commentBody[range])
                if let urlRange = matchedMarkdown.range(of: #"(?<=\()\S+(?=\))"#, options: .regularExpression) {
                    let urlNSRange = NSRange(urlRange, in: commentBody)
                    excludedRanges.insert(urlNSRange)
                }
            }
        }
        
        for match in imageURLMatches {
            let matchRange = match.range
            
            // Skip matches that overlap with excluded ranges
            if excludedRanges.contains(where: { $0.intersection(matchRange) != nil }) {
                continue
            }
            
            // Replace the matched URL with markdown image syntax
            if let range = Range(matchRange, in: commentBody) {
                let matchedString = String(commentBody[range])
                let markdownImage = "![Preview Image](\(matchedString))"
                replacedBody.replaceSubrange(range, with: markdownImage)
            }
        }
        
        for match in imageMarkdownMatches{
            let range = Range(match.range, in: commentBody)!
            let matchedMarkdown = String(commentBody[range])
            let rangeOfCaption = Range(match.range(at: 1), in: commentBody)!
            let matchedCaption = String(commentBody[rangeOfCaption])
            var markdownImage: String
            if matchedCaption.isEmpty {
                markdownImage = "!\(matchedMarkdown)"
            } else {
                markdownImage = "!\(matchedMarkdown)\n\n*\(matchedCaption)*"
            }
            replacedBody = replacedBody.replacingOccurrences(of: matchedMarkdown, with: markdownImage)
        }
        print(replacedBody)
        return replacedBody
    }
    
    static func detectMarkdownTable(_ text: String) -> Bool {
        let markdownTableMatches = MarkdownUtils.REGEX_PATTERNS[3].matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        if markdownTableMatches.count > 0 {
            return true
        }
        return false
    }
}


