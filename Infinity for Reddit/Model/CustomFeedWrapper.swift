//
//  CustomFeedToEdit.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

enum CustomFeedWrapper: Hashable {
    case myCustomFeed(MyCustomFeed)
    case path(String)
    
    var path: String {
        switch self {
        case .myCustomFeed(let myCustomFeed):
            return myCustomFeed.path
        case .path(let path):
            return path
        }
    }
    
    var displayName: String {
        switch self {
        case .myCustomFeed(let myCustomFeed):
            return myCustomFeed.displayName
        case .path(let path):
            return path
        }
    }
    
    var owner: String {
        switch self {
        case .myCustomFeed(let myCustomFeed):
            return myCustomFeed.owner
        case .path(let path):
            let segments = path.split(separator: "/")
            
            guard segments.count == 4 else {
                return ""
            }
            
            return String(segments[1])
        }
    }
}
