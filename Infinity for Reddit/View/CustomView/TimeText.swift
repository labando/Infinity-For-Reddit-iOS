//
//  TimeText.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-10.
//

import SwiftUI

struct TimeText: View {
    @AppStorage(InterfaceTimeFormatUserDefaultsUtils.showElapsedTimeKey, store: .interfaceTimeFormat) private var showElapsedTime: Bool = false
    @AppStorage(InterfaceTimeFormatUserDefaultsUtils.timeFormatKey, store: .interfaceTimeFormat) private var timeFormat: String = InterfaceTimeFormatUserDefaultsUtils.timeFormats[0]
    
    let timeUTCInSeconds: Int64
    let formatter = DateFormatter()
    var forceShowElapsedTime: Bool = false
    
    var formattedFormatter: DateFormatter {
        formatter.dateFormat = timeFormat
        return formatter
    }
    
    var elapsedTime: String {
        let now = Int64(Date().timeIntervalSince1970)
        let diff = now - timeUTCInSeconds
        
        if diff < TimeConstants.minute {
            return "Just Now"
        } else if diff < 2 * TimeConstants.minute {
            return "1 min"
        } else if diff < 50 * TimeConstants.minute {
            return "\(diff / TimeConstants.minute) mins"
        } else if diff < 120 * TimeConstants.minute {
            return "1 hour"
        } else if diff < 24 * TimeConstants.hour {
            return "\(diff / TimeConstants.hour) hours"
        } else if diff < 48 * TimeConstants.hour {
            return "Yesterday"
        } else if diff < TimeConstants.month {
            return "\(diff / TimeConstants.day) days"
        } else if diff < 2 * TimeConstants.month {
            return "1 month"
        } else if diff < TimeConstants.year {
            return "\(diff / TimeConstants.month) months"
        } else if diff < 2 * TimeConstants.year {
            return "1 year"
        } else {
            return "\(diff / TimeConstants.year) years"
        }
    }
    
    var body: some View {
        if showElapsedTime || forceShowElapsedTime {
            Text(elapsedTime)
                .secondaryText()
                .fixedSize(horizontal: false, vertical: true)
        } else {
            Text(formattedFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeUTCInSeconds))))
                .secondaryText()
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
