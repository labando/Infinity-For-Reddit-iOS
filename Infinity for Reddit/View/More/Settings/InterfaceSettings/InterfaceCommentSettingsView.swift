//
//  InterfaceCommentSettingsView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-13.
//

import SwiftUI
import Swinject
import GRDB

struct InterfaceCommentSettingsView: View {
    @AppStorage(InterfaceCommentUserDefaultsUtils.showTopLevelCommentsFirstKey, store: .interfaceCommentFilter)
    private var showTopLevelCommentsFirst: Bool = false
    
    @AppStorage(InterfaceCommentUserDefaultsUtils.showCommentDividerKey, store: .interfaceCommentFilter)
    private var showCommentDivider: Bool = false
    
    @AppStorage(InterfaceCommentUserDefaultsUtils.showOnlyOneCommentLevelIndicatorKey, store: .interfaceCommentFilter)
    private var showOnlyOneCommentLevelIndicator: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.hideToolbarKey, store: .interfaceCommentFilter)
    private var hideToolbar: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.fullyCollapseCommentKey, store: .interfaceCommentFilter)
    private var fullyCollapseComment: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.showAuthorAvatarKey, store: .interfaceCommentFilter)
    private var showAuthorAvatar: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.alwaysShowNChildCommentsKey, store: .interfaceCommentFilter)
    private var alwaysShowNChildComments: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.hideNVotesKey, store: .interfaceCommentFilter)
    private var hideNVotes: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.showFewerToolbarOptionsThresholdKey, store: .interfaceCommentFilter)
    private var showFewerToolbarOptionsThreshold: Int = 0

    @AppStorage(InterfaceCommentUserDefaultsUtils.embeddedMediaTypeKey, store: .interfaceCommentFilter)
    private var embeddedMediaType: Int = 0
    
    var body: some View {
        List {
            TogglePreference(isEnabled: $showTopLevelCommentsFirst, title: "Show Top-level Comments First")
                .listPlainItemNoInsets()
            
            TogglePreference(isEnabled: $showCommentDivider, title: "Show Comment Divider")
                .listPlainItemNoInsets()

            TogglePreference(isEnabled: $showOnlyOneCommentLevelIndicator, title: "Show Only One Comment Level Indicator")
                .listPlainItemNoInsets()

            TogglePreference(isEnabled: $hideToolbar, title: "Hide Comment Toolbar")
                .listPlainItemNoInsets()

            TogglePreference(isEnabled: $fullyCollapseComment, title: "Fully Collapse Comment")
                .listPlainItemNoInsets()

            TogglePreference(isEnabled: $showAuthorAvatar, title: "Show Author Avatar")
                .listPlainItemNoInsets()

            TogglePreference(isEnabled: $alwaysShowNChildComments, title: "Always Show the Number of Child Comments")
                .listPlainItemNoInsets()

            TogglePreference(isEnabled: $hideNVotes, title: "Hide the Number of Votes")
                .listPlainItemNoInsets()
            
//            Picker("Show Fewer Toolbar Options Starting From Level", selection: $showFewerToolbarOptionsThreshold) {
//                ForEach(0..<commentInterfaceViewModel.toolBarOptionLevels.count, id: \.self) { index in
//                    Text(commentInterfaceViewModel.toolBarOptionLevels[index]).tag(index)
//                }
//            }
//            .padding(.leading, 44.5)
//            
//            Picker("Embedded Media Type", selection: $embeddedMediaType) {
//                ForEach(0..<commentInterfaceViewModel.embeddedMediaTypes.count, id: \.self) { index in
//                    Text(commentInterfaceViewModel.embeddedMediaTypes[index]).tag(index)
//                }
//            }
//            .padding(.leading, 44.5)
        }
        .themedList()
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Comment")
    }
}
    
