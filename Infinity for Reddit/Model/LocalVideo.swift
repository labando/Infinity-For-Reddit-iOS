//
//  LocalVideo.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-21.
//

import SwiftUI

struct LocalVideo: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { video in
            SentTransferredFile(video.url)
        } importing: { received in
            let ext = received.file.pathExtension
            
            let destination = URL.documentsDirectory.appending(path: "user_selected_video.\(ext.isEmpty ? "mp4" : ext)")
            
            if FileManager.default.fileExists(atPath: destination.path()) {
                try FileManager.default.removeItem(at: destination)
            }
            
            try FileManager.default.copyItem(at: received.file, to: destination)
            return Self.init(url: destination)
        }
    }
}
