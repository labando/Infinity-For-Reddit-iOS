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
    @AppStorage(InterfaceCommentUserDefaultsUtils.showTopLevelCommentsFirstKey, store: .interfaceComment)
    private var showTopLevelCommentsFirst: Bool = false
    
    @AppStorage(InterfaceCommentUserDefaultsUtils.showCommentDividerKey, store: .interfaceComment)
    private var showCommentDivider: Bool = false
    
    @AppStorage(InterfaceCommentUserDefaultsUtils.showOnlyOneCommentLevelIndicatorKey, store: .interfaceComment)
    private var showOnlyOneCommentLevelIndicator: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.hideToolbarKey, store: .interfaceComment)
    private var hideToolbar: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.fullyCollapseCommentKey, store: .interfaceComment)
    private var fullyCollapseComment: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.showAuthorAvatarKey, store: .interfaceComment)
    private var showAuthorAvatar: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.alwaysShowNChildCommentsKey, store: .interfaceComment)
    private var alwaysShowNChildComments: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.hideNVotesKey, store: .interfaceComment)
    private var hideNVotes: Bool = false

    @AppStorage(InterfaceCommentUserDefaultsUtils.showFewerToolbarOptionsThresholdKey, store: .interfaceComment)
    private var showFewerToolbarOptionsThreshold: Int = 0

    @AppStorage(InterfaceCommentUserDefaultsUtils.embeddedMediaTypeKey, store: .interfaceComment)
    private var embeddedMediaType: Int = 0
    
    let embeddedMediaTypes = ["All", "Image and GIF", "Image and emote", "GIF and emote", "Image", "GIF", "Emote", "None"]
    
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
            
            SliderPreference(
                value: Binding(
                    get: {
                        Float(showFewerToolbarOptionsThreshold)
                    },
                    set: {
                        showFewerToolbarOptionsThreshold = Int($0)
                    }
                ),
                maxValue: 10,
                title: "Show Fewer Toolbar Options Starting From",
                subtitle: "Level \(showFewerToolbarOptionsThreshold)"
            )
            .listPlainItemNoInsets()
            
            PickerPreference(
                selectedIndex: $embeddedMediaType,
                items: embeddedMediaTypes,
                title: "Embedded Media Type"
            )
            .listPlainItemNoInsets()
        }
        .themedList()
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Comment")
    }
}
    
