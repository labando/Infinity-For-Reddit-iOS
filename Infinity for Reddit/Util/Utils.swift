//
//  Utils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-01.
//

import AVFoundation

class Utils {
    static func randomString(length: Int = 6) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in letters.randomElement() })
    }
    
    static func checkCameraAvailability() -> Bool {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified) != nil
    }
}
