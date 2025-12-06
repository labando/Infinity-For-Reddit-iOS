//
//  InterfacePostSettingsView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-11.
//

import Swinject
import GRDB
import SwiftUI

struct InterfacePostSettingsView: View {
    @AppStorage(InterfacePostUserDefaultsUtils.defaultPostLayoutKey, store: .interfacePost) private var defaultPostLayout: Int = 0
    @AppStorage(InterfacePostUserDefaultsUtils.defaultLinkPostLayoutKey, store: .interfacePost) private var defaultLinkPostLayout: Int = 0
    @AppStorage(InterfacePostUserDefaultsUtils.hidePostTypeKey, store: .interfacePost) private var hidePostType: Bool = false
    @AppStorage(InterfacePostUserDefaultsUtils.hidePostFlairKey, store: .interfacePost) private var hidePostFlair: Bool = false
    @AppStorage(InterfacePostUserDefaultsUtils.hideSubredditAndUserPrefixKey, store: .interfacePost) private var hideSubredditAndUserPrefix: Bool = false
    @AppStorage(InterfacePostUserDefaultsUtils.hideNVotesKey, store: .interfacePost) private var hideNVotes: Bool = false
    @AppStorage(InterfacePostUserDefaultsUtils.hideNCommentsKey, store: .interfacePost) private var hideNComments: Bool = false
    @AppStorage(InterfacePostUserDefaultsUtils.hideTextPostContentKey, store: .interfacePost) private var hideTextPostContent: Bool = false
    @AppStorage(InterfacePostUserDefaultsUtils.limitMediaHeightKey, store: .interfacePost) private var limitMediaHeight: Bool = false
    
    var body: some View {
        RootView {
            List {
                BarebonePickerPreference(
                    selected: $defaultPostLayout,
                    items: InterfacePostUserDefaultsUtils.defaultPostLayouts,
                    title: "Default Post Layout"
                ) { layout in
                    InterfacePostUserDefaultsUtils.defaultPostLayoutsText[layout]
                }
                .listPlainItemNoInsets()
                
                BarebonePickerPreference(
                    selected: $defaultLinkPostLayout,
                    items: InterfacePostUserDefaultsUtils.defaultLinkPostLayouts,
                    title: "Default Link Post Layout"
                ) { layout in
                    InterfacePostUserDefaultsUtils.defaultLinkPostLayoutsText[layout]
                }
                .listPlainItemNoInsets()
                
                TogglePreference(isEnabled: $hidePostType, title: "Hide Post Type")
                    .listPlainItemNoInsets()
                
                TogglePreference(isEnabled: $hidePostFlair, title: "Hide Post Flair")
                    .listPlainItemNoInsets()
                
                TogglePreference(isEnabled: $hideSubredditAndUserPrefix, title: "Hide Subreddit and User Prefix")
                    .listPlainItemNoInsets()
                
                TogglePreference(isEnabled: $hideNVotes, title: "Hide the Number of Votes")
                    .listPlainItemNoInsets()
                
                TogglePreference(isEnabled: $hideNComments, title: "Hide the Number of Comments")
                    .listPlainItemNoInsets()
                
                TogglePreference(isEnabled: $hideTextPostContent, title: "Hide Text Post Content")
                    .listPlainItemNoInsets()
                
                TogglePreference(isEnabled: $limitMediaHeight, title: "Limit Media Height")
                    .listPlainItemNoInsets()
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Post")
    }
}


