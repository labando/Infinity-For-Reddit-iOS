//
//  MoreView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-03.
//

import SwiftUI
import Swinject
import GRDB

struct MoreView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @State private var activeAlert: ActiveAlert? = nil
    @State private var previouslyActiveAlertForAnimationCompletion: ActiveAlert? = nil
    @State private var handleLinkUrlString: String = ""
    @State private var subredditName: String = ""
    @State private var username: String = ""
    @FocusState private var focusedField: FieldType?
    
    var body: some View {
        RootView {
            List {
                CustomListSection("Reddit") {
                    SimpleTouchItemRow(text: "Popular", icon: "flame") {
                        navigationManager.append(MoreViewNavigation.popular)
                    }
                    .listPlainItemNoInsets()
                    
                    SimpleTouchItemRow(text: "All", icon: "globe") {
                        navigationManager.append(MoreViewNavigation.all)
                    }
                    .listPlainItemNoInsets()
                    
                    if !accountViewModel.account.isAnonymous() {
                        SimpleTouchItemRow(text: "Search", icon: "magnifyingglass") {
                            navigationManager.append(AppNavigation.search)
                        }
                        .listPlainItemNoInsets()
                    }
                    
                    SimpleTouchItemRow(text: "Handle Link", icon: "link") {
                        withAnimation(.linear(duration: 0.2)) {
                            handleLinkUrlString = ""
                            activeAlert = .handleLink
                        }
                        //navigationManager.openLink("https://imgur.com/gallery/scattershot-2-first-monsoon-of-year-has-arrived-vE6YoyH#/t/album")
                    }
                    .listPlainItemNoInsets()
                    
                    SimpleTouchItemRow(text: "Go to Subreddit", icon: "bubble.left.and.text.bubble.right") {
                        withAnimation(.linear(duration: 0.2)) {
                            subredditName = ""
                            activeAlert = .goToSubreddit
                        }
                    }
                    .listPlainItemNoInsets()
                    
                    SimpleTouchItemRow(text: "Go to User", icon: "person.crop.circle") {
                        withAnimation(.linear(duration: 0.2)) {
                            username = ""
                            activeAlert = .goToUser
                        }
                    }
                    .listPlainItemNoInsets()
                }
                
                CustomListSection("Account") {
                    if !accountViewModel.account.isAnonymous() {
                        SimpleTouchItemRow(text: "Profile", icon: "person.crop.circle") {
                            navigationManager.append(AppNavigation.userDetails(username: accountViewModel.account.username))
                        }
                        .listPlainItemNoInsets()
                    }
                    
                    SimpleTouchItemRow(text: "Upvoted", icon:"arrowshape.up") {
                        navigationManager.append(MoreViewNavigation.upvoted)
                    }
                    .listPlainItemNoInsets()
                    
                    SimpleTouchItemRow(text: "Downvoted", icon: "arrowshape.down") {
                        navigationManager.append(MoreViewNavigation.downvoted)
                    }
                    .listPlainItemNoInsets()
                    
                    SimpleTouchItemRow(text: "Hidden", icon: "eye.slash") {
                        navigationManager.append(MoreViewNavigation.hidden)
                    }
                    .listPlainItemNoInsets()
                    
                    SimpleTouchItemRow(text: "Saved", icon: "bookmark.fill") {
                        navigationManager.append(MoreViewNavigation.saved)
                    }
                    .listPlainItemNoInsets()
                    
                    SimpleTouchItemRow(text: "History", icon: "clock") {
                        navigationManager.append(MoreViewNavigation.history)
                    }
                    .listPlainItemNoInsets()
                }
                
                CustomListSection("Preferences") {
                    SimpleTouchItemRow(text: "Settings", icon: "gearshape") {
                        navigationManager.append(MoreViewNavigation.settings)
                    }
                    .listPlainItemNoInsets()
                    
                    SimpleTouchItemRow(text: "Test", icon: "testtube.2") {
                        navigationManager.append(MoreViewNavigation.test)
                    }
                    .listPlainItemNoInsets()
                }
            }
            .themedList()
        }
        .overlay(
            CustomAlert(title: activeAlert?.title ?? "", confirmButtonText: "Go", isPresented: Binding(
                get: { activeAlert != nil },
                set: { newValue in
                    if !newValue {
                        activeAlert = nil
                    }
                }
            )) {
                switch activeAlert {
                case .handleLink:
                    CustomTextField(
                        "URL",
                        text: $handleLinkUrlString,
                        singleLine: true,
                        autocapitalization: .never,
                        fieldType: .handleLink,
                        focusedField: $focusedField
                    )
                    .urlTextField()
                    .submitLabel(.go)
                    .onSubmit {
                        withAnimation {
                            activeAlert = nil
                        } completion: {
                            navigationManager.openLink(handleLinkUrlString)
                        }
                    }
                case .goToSubreddit:
                    CustomTextField(
                        "Subreddit name",
                        text: $subredditName,
                        singleLine: true,
                        autocapitalization: .never,
                        fieldType: .subredditName,
                        focusedField: $focusedField
                    )
                    .submitLabel(.go)
                    .onSubmit {
                        navigationManager.append(AppNavigation.subredditDetails(subredditName: subredditName))
                        activeAlert = nil
                    }
                    
                    SubredditAutoCompleteView(query: $subredditName, itemPadding: 8) { subreddit in
                        navigationManager.append(
                            AppNavigation.subredditDetails(subredditName: subreddit.displayName)
                        )
                        withAnimation {
                            activeAlert = nil
                        }
                    }
                case .goToUser:
                    CustomTextField(
                        "Username",
                        text: $username,
                        singleLine: true,
                        autocapitalization: .never,
                        fieldType: .username,
                        focusedField: $focusedField
                    )
                    .submitLabel(.go)
                    .onSubmit {
                        navigationManager.append(AppNavigation.userDetails(username: username))
                        activeAlert = nil
                    }
                case nil:
                    EmptyView()
                }
            } onConfirm: {
                if let alert = activeAlert {
                    switch alert {
                    case .handleLink:
                        previouslyActiveAlertForAnimationCompletion = .handleLink
                        focusedField = nil
                    case .goToSubreddit:
                        previouslyActiveAlertForAnimationCompletion = nil
                        navigationManager.append(AppNavigation.subredditDetails(subredditName: subredditName))
                    case .goToUser:
                        previouslyActiveAlertForAnimationCompletion = nil
                        navigationManager.append(AppNavigation.userDetails(username: username))
                    }
                }
            } onConfirmAnimationCompleted: {
                // This is only for .handleLink cuz when a full screen media view that contains a TabView shows, the navigation bar will have a weird top padding. Stupid.
                if let alert = previouslyActiveAlertForAnimationCompletion {
                    switch alert {
                    case .handleLink:
                        previouslyActiveAlertForAnimationCompletion = nil
                        focusedField = nil
                        navigationManager.openLink(handleLinkUrlString)
                    default:
                        break
                    }
                }
            }
        )
    }
    
    enum FieldType: Hashable {
        case handleLink
        case subredditName
        case username
    }
}

private enum ActiveAlert: Identifiable {
    case handleLink, goToSubreddit, goToUser

    var id: Int {
        hashValue
    }
    
    var title: String {
        switch self {
        case .handleLink: return "Handle Link"
        case .goToSubreddit: return "Go to Subreddit"
        case .goToUser: return "Go to User"
        }
    }
}
