//
//  CustomTheme.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-10.
//

import GRDB


struct CustomTheme: Codable, FetchableRecord, PersistableRecord {
    var id: Int?
    var name: String
    var username: String?
    var isLightTheme: Bool
    var isDarkTheme: Bool
    var isAmoledTheme: Bool
    var colorPrimary: Int
    var colorPrimaryDark: Int
    var colorAccent: Int
    var colorPrimaryLightTheme: Int
    var primaryTextColor: Int
    var secondaryTextColor: Int
    var postTitleColor: Int
    var postContentColor: Int
    var readPostTitleColor: Int
    var readPostContentColor: Int
    var commentColor: Int
    var buttonTextColor: Int
    var backgroundColor: Int
    var cardViewBackgroundColor: Int
    var readPostCardViewBackgroundColor: Int
    var filledCardViewBackgroundColor: Int
    var readPostFilledCardViewBackgroundColor: Int
    var commentBackgroundColor: Int
    var bottomAppBarBackgroundColor: Int
    var primaryIconColor: Int
    var bottomAppBarIconColor: Int
    var postIconAndInfoColor: Int
    var commentIconAndInfoColor: Int
    var toolbarPrimaryTextAndIconColor: Int
    var toolbarSecondaryTextColor: Int
    var circularProgressBarBackground: Int
    var mediaIndicatorIconColor: Int
    var mediaIndicatorBackgroundColor: Int
    var tabLayoutWithExpandedCollapsingToolbarTabBackground: Int
    var tabLayoutWithExpandedCollapsingToolbarTextColor: Int
    var tabLayoutWithExpandedCollapsingToolbarTabIndicator: Int
    var tabLayoutWithCollapsedCollapsingToolbarTabBackground: Int
    var tabLayoutWithCollapsedCollapsingToolbarTextColor: Int
    var tabLayoutWithCollapsedCollapsingToolbarTabIndicator: Int
    var navBarColor: Int
    var upvoted: Int
    var downvoted: Int
    var postTypeBackgroundColor: Int
    var postTypeTextColor: Int
    var spoilerBackgroundColor: Int
    var spoilerTextColor: Int
    var nsfwBackgroundColor: Int
    var nsfwTextColor: Int
    var flairBackgroundColor: Int
    var flairTextColor: Int
    var awardsBackgroundColor: Int
    var awardsTextColor: Int
    var archivedTint: Int
    var lockedIconTint: Int
    var crosspostIconTint: Int
    var upvoteRatioIconTint: Int
    var stickiedPostIconTint: Int
    var noPreviewPostTypeIconTint: Int
    var subscribed: Int
    var unsubscribed: Int
    var subreddit: Int
    var authorFlairTextColor: Int
    var submitter: Int
    var moderator: Int
    var currentUser: Int
    var singleCommentThreadBackgroundColor: Int
    var unreadMessageBackgroundColor: Int
    var dividerColor: Int
    var noPreviewPostTypeBackgroundColor: Int
    var voteAndReplyUnavailableButtonColor: Int
    var commentVerticalBarColor1: Int
    var commentVerticalBarColor2: Int
    var commentVerticalBarColor3: Int
    var commentVerticalBarColor4: Int
    var commentVerticalBarColor5: Int
    var commentVerticalBarColor6: Int
    var commentVerticalBarColor7: Int
    var fabIconColor: Int
    var chipTextColor: Int
    var linkColor: Int
    var receivedMessageTextColor: Int
    var sentMessageTextColor: Int
    var receivedMessageBackgroundColor: Int
    var sentMessageBackgroundColor: Int
    var sendMessageIconColor: Int
    var fullyCollapsedCommentBackgroundColor: Int
    var awardedCommentBackgroundColor: Int
    var isLightStatusBar: Bool
    var isLightNavBar: Bool
    var isChangeStatusBarIconColorAfterToolbarCollapsedInImmersiveInterface: Bool
    
    static var databaseTableName: String {
        return "custom_theme"
    }
    
    init(
        name: String,
        username: String?,
        isLightTheme: Bool,
        isDarkTheme: Bool,
        isAmoledTheme: Bool,
        colorPrimary: Int,
        colorPrimaryDark: Int,
        colorAccent: Int,
        colorPrimaryLightTheme: Int,
        primaryTextColor: Int,
        secondaryTextColor: Int,
        postTitleColor: Int,
        postContentColor: Int,
        readPostTitleColor: Int,
        readPostContentColor: Int,
        commentColor: Int,
        buttonTextColor: Int,
        backgroundColor: Int,
        cardViewBackgroundColor: Int,
        readPostCardViewBackgroundColor: Int,
        filledCardViewBackgroundColor: Int,
        readPostFilledCardViewBackgroundColor: Int,
        commentBackgroundColor: Int,
        bottomAppBarBackgroundColor: Int,
        primaryIconColor: Int,
        bottomAppBarIconColor: Int,
        postIconAndInfoColor: Int,
        commentIconAndInfoColor: Int,
        toolbarPrimaryTextAndIconColor: Int,
        toolbarSecondaryTextColor: Int,
        circularProgressBarBackground: Int,
        mediaIndicatorIconColor: Int,
        mediaIndicatorBackgroundColor: Int,
        tabLayoutWithExpandedCollapsingToolbarTabBackground: Int,
        tabLayoutWithExpandedCollapsingToolbarTextColor: Int,
        tabLayoutWithExpandedCollapsingToolbarTabIndicator: Int,
        tabLayoutWithCollapsedCollapsingToolbarTabBackground: Int,
        tabLayoutWithCollapsedCollapsingToolbarTextColor: Int,
        tabLayoutWithCollapsedCollapsingToolbarTabIndicator: Int,
        navBarColor: Int,
        upvoted: Int,
        downvoted: Int,
        postTypeBackgroundColor: Int,
        postTypeTextColor: Int,
        spoilerBackgroundColor: Int,
        spoilerTextColor: Int,
        nsfwBackgroundColor: Int,
        nsfwTextColor: Int,
        flairBackgroundColor: Int,
        flairTextColor: Int,
        awardsBackgroundColor: Int,
        awardsTextColor: Int,
        archivedTint: Int,
        lockedIconTint: Int,
        crosspostIconTint: Int,
        upvoteRatioIconTint: Int,
        stickiedPostIconTint: Int,
        noPreviewPostTypeIconTint: Int,
        subscribed: Int,
        unsubscribed: Int,
        subreddit: Int,
        authorFlairTextColor: Int,
        submitter: Int,
        moderator: Int,
        currentUser: Int,
        singleCommentThreadBackgroundColor: Int,
        unreadMessageBackgroundColor: Int,
        dividerColor: Int,
        noPreviewPostTypeBackgroundColor: Int,
        voteAndReplyUnavailableButtonColor: Int,
        commentVerticalBarColor1: Int,
        commentVerticalBarColor2: Int,
        commentVerticalBarColor3: Int,
        commentVerticalBarColor4: Int,
        commentVerticalBarColor5: Int,
        commentVerticalBarColor6: Int,
        commentVerticalBarColor7: Int,
        fabIconColor: Int,
        chipTextColor: Int,
        linkColor: Int,
        receivedMessageTextColor: Int,
        sentMessageTextColor: Int,
        receivedMessageBackgroundColor: Int,
        sentMessageBackgroundColor: Int,
        sendMessageIconColor: Int,
        fullyCollapsedCommentBackgroundColor: Int,
        awardedCommentBackgroundColor: Int,
        isLightStatusBar: Bool,
        isLightNavBar: Bool,
        isChangeStatusBarIconColorAfterToolbarCollapsedInImmersiveInterface: Bool
    ) {
        self.name = name
        self.username = username
        self.isLightTheme = isLightTheme
        self.isDarkTheme = isDarkTheme
        self.isAmoledTheme = isAmoledTheme
        self.colorPrimary = colorPrimary
        self.colorPrimaryDark = colorPrimaryDark
        self.colorAccent = colorAccent
        self.colorPrimaryLightTheme = colorPrimaryLightTheme
        self.primaryTextColor = primaryTextColor
        self.secondaryTextColor = secondaryTextColor
        self.postTitleColor = postTitleColor
        self.postContentColor = postContentColor
        self.readPostTitleColor = readPostTitleColor
        self.readPostContentColor = readPostContentColor
        self.commentColor = commentColor
        self.buttonTextColor = buttonTextColor
        self.backgroundColor = backgroundColor
        self.cardViewBackgroundColor = cardViewBackgroundColor
        self.readPostCardViewBackgroundColor = readPostCardViewBackgroundColor
        self.filledCardViewBackgroundColor = filledCardViewBackgroundColor
        self.readPostFilledCardViewBackgroundColor = readPostFilledCardViewBackgroundColor
        self.commentBackgroundColor = commentBackgroundColor
        self.bottomAppBarBackgroundColor = bottomAppBarBackgroundColor
        self.primaryIconColor = primaryIconColor
        self.bottomAppBarIconColor = bottomAppBarIconColor
        self.postIconAndInfoColor = postIconAndInfoColor
        self.commentIconAndInfoColor = commentIconAndInfoColor
        self.toolbarPrimaryTextAndIconColor = toolbarPrimaryTextAndIconColor
        self.toolbarSecondaryTextColor = toolbarSecondaryTextColor
        self.circularProgressBarBackground = circularProgressBarBackground
        self.mediaIndicatorIconColor = mediaIndicatorIconColor
        self.mediaIndicatorBackgroundColor = mediaIndicatorBackgroundColor
        self.tabLayoutWithExpandedCollapsingToolbarTabBackground = tabLayoutWithExpandedCollapsingToolbarTabBackground
        self.tabLayoutWithExpandedCollapsingToolbarTextColor = tabLayoutWithExpandedCollapsingToolbarTextColor
        self.tabLayoutWithExpandedCollapsingToolbarTabIndicator = tabLayoutWithExpandedCollapsingToolbarTabIndicator
        self.tabLayoutWithCollapsedCollapsingToolbarTabBackground = tabLayoutWithCollapsedCollapsingToolbarTabBackground
        self.tabLayoutWithCollapsedCollapsingToolbarTextColor = tabLayoutWithCollapsedCollapsingToolbarTextColor
        self.tabLayoutWithCollapsedCollapsingToolbarTabIndicator = tabLayoutWithCollapsedCollapsingToolbarTabIndicator
        self.navBarColor = navBarColor
        self.upvoted = upvoted
        self.downvoted = downvoted
        self.postTypeBackgroundColor = postTypeBackgroundColor
        self.postTypeTextColor = postTypeTextColor
        self.spoilerBackgroundColor = spoilerBackgroundColor
        self.spoilerTextColor = spoilerTextColor
        self.nsfwBackgroundColor = nsfwBackgroundColor
        self.nsfwTextColor = nsfwTextColor
        self.flairBackgroundColor = flairBackgroundColor
        self.flairTextColor = flairTextColor
        self.awardsBackgroundColor = awardsBackgroundColor
        self.awardsTextColor = awardsTextColor
        self.archivedTint = archivedTint
        self.lockedIconTint = lockedIconTint
        self.crosspostIconTint = crosspostIconTint
        self.upvoteRatioIconTint = upvoteRatioIconTint
        self.stickiedPostIconTint = stickiedPostIconTint
        self.noPreviewPostTypeIconTint = noPreviewPostTypeIconTint
        self.subscribed = subscribed
        self.unsubscribed = unsubscribed
        self.subreddit = subreddit
        self.authorFlairTextColor = authorFlairTextColor
        self.submitter = submitter
        self.moderator = moderator
        self.currentUser = currentUser
        self.singleCommentThreadBackgroundColor = singleCommentThreadBackgroundColor
        self.unreadMessageBackgroundColor = unreadMessageBackgroundColor
        self.dividerColor = dividerColor
        self.noPreviewPostTypeBackgroundColor = noPreviewPostTypeBackgroundColor
        self.voteAndReplyUnavailableButtonColor = voteAndReplyUnavailableButtonColor
        self.commentVerticalBarColor1 = commentVerticalBarColor1
        self.commentVerticalBarColor2 = commentVerticalBarColor2
        self.commentVerticalBarColor3 = commentVerticalBarColor3
        self.commentVerticalBarColor4 = commentVerticalBarColor4
        self.commentVerticalBarColor5 = commentVerticalBarColor5
        self.commentVerticalBarColor6 = commentVerticalBarColor6
        self.commentVerticalBarColor7 = commentVerticalBarColor7
        self.fabIconColor = fabIconColor
        self.chipTextColor = chipTextColor
        self.linkColor = linkColor
        self.receivedMessageTextColor = receivedMessageTextColor
        self.sentMessageTextColor = sentMessageTextColor
        self.receivedMessageBackgroundColor = receivedMessageBackgroundColor
        self.sentMessageBackgroundColor = sentMessageBackgroundColor
        self.sendMessageIconColor = sendMessageIconColor
        self.fullyCollapsedCommentBackgroundColor = fullyCollapsedCommentBackgroundColor
        self.awardedCommentBackgroundColor = awardedCommentBackgroundColor
        self.isLightStatusBar = isLightStatusBar
        self.isLightNavBar = isLightNavBar
        self.isChangeStatusBarIconColorAfterToolbarCollapsedInImmersiveInterface = isChangeStatusBarIconColorAfterToolbarCollapsedInImmersiveInterface
    }
}
