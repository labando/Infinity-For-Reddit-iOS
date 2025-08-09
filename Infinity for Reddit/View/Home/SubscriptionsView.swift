//
//  SubscriptionsView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-03.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct SubscriptionsView: View {
    @EnvironmentObject private var accountViewModel: AccountViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    @StateObject var subscriptionListingViewModel: SubscriptionListingViewModel

    @State private var selectedOption = 0
    
    init() {
        _subscriptionListingViewModel = StateObject(
            wrappedValue: SubscriptionListingViewModel(
                subscriptionListingRepository: SubscriptionListingRepository()
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            SegmentedPicker(selectedValue: $selectedOption, values: ["Subreddits", "Users", "Custom Feed"])
                .padding(4)
            
            TabView(selection: $selectedOption) {
                SubredditsView(subscriptionListingViewModel: subscriptionListingViewModel)
                    .tag(0)
                
                UsersView(subscriptionListingViewModel: subscriptionListingViewModel)
                    .tag(1)
                
                CustomFeedView(subscriptionListingViewModel: subscriptionListingViewModel)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("Subscriptions")
        .task {
            await subscriptionListingViewModel.loadSubscriptionsOnline()
            await subscriptionListingViewModel.loadMyCustomFeedsOnline()
        }
    }
    
    struct SubredditsView: View {
        @EnvironmentObject var navigationManager: NavigationManager
        @ObservedObject var subscriptionListingViewModel: SubscriptionListingViewModel
        
        var body: some View {
            Group {
                if subscriptionListingViewModel.subredditSubscriptions.isEmpty {
                    if subscriptionListingViewModel.isLoadingSubscriptions {
                        ProgressIndicator()
                    } else {
                        Text("No subscribed subreddits")
                            .primaryText()
                    }
                } else {
                    List {
                        ForEach(subscriptionListingViewModel.subredditSubscriptions, id: \.fullName) { subscription in
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

    struct UsersView: View {
        @EnvironmentObject var navigationManager: NavigationManager
        @ObservedObject var subscriptionListingViewModel: SubscriptionListingViewModel
        
        var body: some View {
            Group {
                if subscriptionListingViewModel.userSubscriptions.isEmpty {
                    if subscriptionListingViewModel.isLoadingSubscriptions {
                        ProgressIndicator()
                    } else {
                        Text("No subscribed users")
                            .primaryText()
                    }
                } else {
                    List {
                        ForEach(subscriptionListingViewModel.userSubscriptions, id: \.name) { subscription in
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

    struct CustomFeedView: View {
        @EnvironmentObject var navigationManager: NavigationManager
        @ObservedObject var subscriptionListingViewModel: SubscriptionListingViewModel
        
        var body: some View {
            Group {
                if subscriptionListingViewModel.myCustomFeeds.isEmpty {
                    if subscriptionListingViewModel.isLoadingMyCustomFeeds {
                        ProgressIndicator()
                    } else {
                        Text("No custom feeds")
                            .primaryText()
                    }
                } else {
                    List {
                        ForEach(subscriptionListingViewModel.myCustomFeeds, id: \.path) { customFeed in
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
