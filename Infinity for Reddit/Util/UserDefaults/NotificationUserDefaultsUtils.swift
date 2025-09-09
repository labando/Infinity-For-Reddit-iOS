//
//  NotificationUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-09.
//

import Foundation

class NotificationUserDefaultsUtils {
    static let enableNotificationKey = "enable_notification"
    static var enableNotification: Bool {
        return UserDefaults.video.bool(forKey: enableNotificationKey, true)
    }
    
    static let notificationIntervalKey = "notification_interval"
    static var notificationInterval: Int {
        return UserDefaults.video.integer(forKey: notificationIntervalKey)
    }
    static let notificationIntervalOptions: [Int] = [15, 30, 60, 120, 180, 240, 360, 720, 1440]
    static let notificationIntervalOptionsText: [String] = ["15 mins", "30 mins", "1 hr", "2 hrs", "3 hrs", "4 hrs", "6 hrs", "12 hrs", "24 hrs"]
}
