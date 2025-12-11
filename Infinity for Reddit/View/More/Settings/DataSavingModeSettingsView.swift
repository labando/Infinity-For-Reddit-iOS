//
// DataSavingModeSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI

struct DataSavingModeSettingsView: View {
    @AppStorage(DataSavingModeUserDefaultsUtils.dataSavingModeKey, store: .dataSavingMode) private var dataSavingMode: Int = 0
    @AppStorage(DataSavingModeUserDefaultsUtils.disableImagePreviewKey, store: .dataSavingMode) private var disableImagePreview: Bool = false
    @AppStorage(DataSavingModeUserDefaultsUtils.onlyDisablePreviewInVideoAndGIFKey, store: .dataSavingMode) private var onlyDisablePreviewInVideoAndGIF: Bool = false

    var body: some View {
        RootView {
            ScrollView {
                VStack(spacing: 0) {
                    InfoPreference(title: "In data saving mode:\nPreview images are in lower resolution.\nVideo autoplay is disabled.",
                                   icon: "info.circle"
                    )
                    
                    BarebonePickerPreference(
                        selected: $dataSavingMode,
                        items: DataSavingModeUserDefaultsUtils.dataSavingModeOptions,
                        title: "Data Saving Mode"
                    ) { mode in
                        DataSavingModeUserDefaultsUtils.dataSavingModeOptionsText[mode]
                    }
                    
                    if dataSavingMode != 0 {
                        TogglePreference(
                            isEnabled: $disableImagePreview,
                            title: "Disable Image Preview in Data Saving Mode"
                        )
                        .transition(.opacity)

                        TogglePreference(
                            isEnabled: $onlyDisablePreviewInVideoAndGIF,
                            title: "Only Disable Preview in Video and Gif Posts"
                        )
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: dataSavingMode)
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Data Saving Mode")
    }
}
