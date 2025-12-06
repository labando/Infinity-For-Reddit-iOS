//
//  InterfaceTimeFormatSettingsView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-07.
//  

import SwiftUI
import Swinject
import GRDB

struct InterfaceTimeFormatSettingsView: View {
    @AppStorage(InterfaceTimeFormatUserDefaultsUtils.showElapsedTimeKey, store: .interfaceTimeFormat) private var showElapsedTime: Bool = false
    @AppStorage(InterfaceTimeFormatUserDefaultsUtils.timeFormatKey, store: .interfaceTimeFormat) private var timeFormat: String = InterfaceTimeFormatUserDefaultsUtils.timeFormats[0]
    
    @State private var showElapsedTimeMirror: Bool
    
    init() {
        showElapsedTimeMirror = InterfaceTimeFormatUserDefaultsUtils.showElapsedTime
    }

    var body: some View {
        RootView {
            List {
                TogglePreference(isEnabled: $showElapsedTime, title: "Show Elapsed Time")
                    .listPlainItemNoInsets()
                
                if !showElapsedTimeMirror {
                    BarebonePickerPreference(
                        selected: $timeFormat,
                        items: InterfaceTimeFormatUserDefaultsUtils.timeFormats,
                        title: "Time Format"
                    ) { format in
                        InterfaceTimeFormatUserDefaultsUtils.timeFormatsText[InterfaceTimeFormatUserDefaultsUtils.timeFormats.firstIndex(of: format) ?? 0]
                    }
                    .listPlainItemNoInsets()
                }
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Time Format")
        .onChange(of: showElapsedTime) { oldValue, newValue in
            withAnimation {
                showElapsedTimeMirror = newValue
            }
        }
    }
}
