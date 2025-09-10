//
//  InterfaceTimeFormatUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-10.
//

import Foundation

class InterfaceTimeFormatUserDefaultsUtils {
    static let showElapsedTimeKey = "show_elapsed_time"
    static var showElapsedTime: Bool {
        return UserDefaults.interfaceTimeFormat.bool(forKey: showElapsedTimeKey)
    }
    
    static let timeFormatKey = "time_format"
    static var timeFormat: String {
        return UserDefaults.interfacePost.string(forKey: timeFormatKey, "MMM d, yyyy, HH:mm")
    }
    static let timeFormats = [
        "MMM d, yyyy, HH:mm",
        "MMM d, yyyy, hh:mm a",
        "d MMM yyyy, HH:mm",
        "d MMM yyyy, hh:mm a",
        "M/d/yyyy HH:mm",
        "M/d/yyyy hh:mm a",
        "d/M/yyyy HH:mm",
        "d/M/yyyy hh:mm a",
        "yyyy/M/d HH:mm",
        "yyyy/M/d hh:mm a",
        "M-d-yyyy HH:mm",
        "M-d-yyyy hh:mm a",
        "d-M-yyyy HH:mm",
        "d-M-yyyy hh:mm a",
        "yyyy-M-d HH:mm",
        "yyyy-M-d hh:mm a",
        "M.d.yyyy HH:mm",
        "M.d.yyyy hh:mm a",
        "d.M.yyyy HH:mm",
        "d.M.yyyy hh:mm a",
        "yyyy.M.d HH:mm",
        "yyyy.M.d hh:mm a"
    ]
    static let timeFormatsText = [
        "Jan 23, 2020, 23:45",
        "Jan 23, 2020, 11:45 PM",
        "23 Jan, 2020, 23:45",
        "23 Jan, 2020, 11:45 PM",
        "1/23/2020 23:45",
        "1/23/2020 11:45 PM",
        "23/1/2020 23:45",
        "23/1/2020 11:45 PM",
        "2020/1/23 23:45",
        "2020/1/23 11:45 PM",
        "1-23-2020 23:45",
        "1-23-2020 11:45 PM",
        "23-1-2020 23:45",
        "23-1-2020 11:45 PM",
        "2020-1-23 23:45",
        "2020-1-23 11:45 PM",
        "1.23.2020 23:45",
        "1.23.2020 11:45 PM",
        "23.1.2020 23:45",
        "23.1.2020 11:45 PM",
        "2020.1.23 23:45",
        "2020.1.23 11:45 PM"
    ]
}
