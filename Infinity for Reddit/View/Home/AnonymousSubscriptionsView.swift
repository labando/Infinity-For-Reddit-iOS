//
//  AnonymousSubscriptionsView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-08.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct AnonymousSubscriptionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    @StateObject var anonymousSubscriptionListingViewModel: AnonymousSubscriptionListingViewModel

    @State private var selectedOption = 0
    
    init() {
        _anonymousSubscriptionListingViewModel = StateObject(
            wrappedValue: AnonymousSubscriptionListingViewModel()
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            SegmentedPicker(selectedValue: $selectedOption, values: ["Subreddits", "Users", "Custom Feed"])
                .padding(4)
            
            TabView(selection: $selectedOption) {
                AnonymousSubredditsView(anonymousSubscriptionListingViewModel: anonymousSubscriptionListingViewModel)
                    .tag(0)
                
                AnonymousUsersView(anonymousSubscriptionListingViewModel: anonymousSubscriptionListingViewModel)
                    .tag(1)
                
                AnonymousCustomFeedView(anonymousSubscriptionListingViewModel: anonymousSubscriptionListingViewModel)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("Subscriptions")
    }
    
    struct AnonymousSubredditsView: View {
        @EnvironmentObject var navigationManager: NavigationManager
        @ObservedObject var anonymousSubscriptionListingViewModel: AnonymousSubscriptionListingViewModel
        
        var body: some View {
            Group {
                if anonymousSubscriptionListingViewModel.subredditSubscriptions.isEmpty {
                    Text("No subscribed subreddits")
                        .primaryText()
                } else {
                    List {
                        ForEach(anonymousSubscriptionListingViewModel.subredditSubscriptions, id: \.fullName) { subscription in
                            SimpleWebImageTouchItemRow(text: subscription.name, iconUrl: subscription.iconUrl) {
                                navigationManager.path.append(AppNavigation.subredditDetails(subredditName: subscription.name))
                            }
                            .listPlainItemNoInsets()
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .themedList()
                }
            }
        }
    }

    struct AnonymousUsersView: View {
        @EnvironmentObject var navigationManager: NavigationManager
        @ObservedObject var anonymousSubscriptionListingViewModel: AnonymousSubscriptionListingViewModel
        
        var body: some View {
            Group {
                if anonymousSubscriptionListingViewModel.userSubscriptions.isEmpty {
                    Text("No subscribed users")
                        .primaryText()
                } else {
                    List {
                        ForEach(anonymousSubscriptionListingViewModel.userSubscriptions, id: \.name) { subscription in
                            SimpleWebImageTouchItemRow(text: subscription.name, iconUrl: subscription.iconUrl) {
                                navigationManager.path.append(AppNavigation.userDetails(username: subscription.name))
                            }
                            .listPlainItemNoInsets()
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .themedList()
                }
            }
        }
    }

    struct AnonymousCustomFeedView: View {
        @EnvironmentObject var navigationManager: NavigationManager
        @ObservedObject var anonymousSubscriptionListingViewModel: AnonymousSubscriptionListingViewModel
        
        var body: some View {
            Group {
                if anonymousSubscriptionListingViewModel.myCustomFeeds.isEmpty {
                    Text("No custom feeds")
                        .primaryText()
                } else {
                    List {
                        ForEach(anonymousSubscriptionListingViewModel.myCustomFeeds, id: \.path) { customFeed in
                            SimpleWebImageTouchItemRow(text: customFeed.displayName, iconUrl: customFeed.iconUrl) {
                                navigationManager.path.append(AppNavigation.customFeed(myCustomFeed: customFeed))
                            }
                            .listPlainItemNoInsets()
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .themedList()
                }
            }
        }
    }
}
