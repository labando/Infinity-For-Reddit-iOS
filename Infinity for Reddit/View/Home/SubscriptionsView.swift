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
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var accountViewModel: AccountViewModel
    @EnvironmentObject private var navigationBarMenuManager: NavigationBarMenuManager
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @StateObject var subscriptionListingViewModel: SubscriptionListingViewModel

    @State private var selectedOption = 0
    @State private var navigationBarMenuKey: UUID?
    
    init(subscriptionSelectionMode: ThingSelectionMode = .noSelection) {
        _subscriptionListingViewModel = StateObject(
            wrappedValue: SubscriptionListingViewModel(
                subscriptionSelectionMode: subscriptionSelectionMode,
                subscriptionListingRepository: SubscriptionListingRepository()
            )
        )
    }

    var body: some View {
        RootView {
            VStack(spacing: 0) {
                switch subscriptionListingViewModel.subscriptionSelectionMode {
                case .subredditAndUserMultiSelection:
                    SegmentedPicker(
                        selectedValue: $selectedOption,
                        values: ["Subreddits", "Users"]
                    )
                    .padding(4)
                case .subredditMultiSelection:
                    EmptyView()
                case .userMultiSelection:
                    EmptyView()
                default:
                    SegmentedPicker(
                        selectedValue: $selectedOption,
                        values: ["Subreddits", "Users", "Custom Feed"]
                    )
                    .padding(4)
                }
                
                TabView(selection: $selectedOption) {
                    Group {
                        switch subscriptionListingViewModel.subscriptionSelectionMode {
                        case .noSelection:
                            SubscribedSubredditListingView(subscriptionListingViewModel: subscriptionListingViewModel)
                                .tag(0)
                            
                            SubscribedUserListingView(subscriptionListingViewModel: subscriptionListingViewModel, onSelectCustomAction: nil)
                                .tag(1)
                            
                            CustomFeedListingView(subscriptionListingViewModel: subscriptionListingViewModel, onSelectCustomAction: nil)
                                .tag(2)
                        case .thingSelection(let onSelectThing):
                            SubscribedSubredditListingView(subscriptionListingViewModel: subscriptionListingViewModel) { subscribedSubredditData in
                                onSelectThing(Thing.subscribedSubreddit(subscribedSubredditData))
                            }
                            .tag(0)
                            
                            SubscribedUserListingView(subscriptionListingViewModel: subscriptionListingViewModel) { subscribedUserData in
                                onSelectThing(Thing.subscribedUser(subscribedUserData))
                            }
                            .tag(1)
                            
                            CustomFeedListingView(subscriptionListingViewModel: subscriptionListingViewModel, onSelectCustomAction: onSelectThing)
                                .tag(2)
                        case .subredditAndUserMultiSelection:
                            SubscribedSubredditListingMultiSelectionView(subscriptionListingViewModel: subscriptionListingViewModel)
                                .tag(0)
                            
                            SubscribedUserListingMultiSelectionView(subscriptionListingViewModel: subscriptionListingViewModel)
                                .tag(1)
                        case .subredditMultiSelection:
                            SubscribedSubredditListingMultiSelectionView(subscriptionListingViewModel: subscriptionListingViewModel)
                                .tag(0)
                        case .userMultiSelection:
                            SubscribedUserListingMultiSelectionView(subscriptionListingViewModel: subscriptionListingViewModel)
                                .tag(0)
                        }
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
                
                switch subscriptionListingViewModel.subscriptionSelectionMode {
                case .subredditAndUserMultiSelection(_, let onSelectMultipleSubscriptions):
                    Button {
                        onSelectMultipleSubscriptions(subscriptionListingViewModel.getSelectedSubredditsAndUsers())
                        dismiss()
                    } label: {
                        HStack {
                            Text("Done")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                    .filledButton()
                case .subredditMultiSelection(_, let onConfirmSelection):
                    Button {
                        onConfirmSelection(subscriptionListingViewModel.getSelectedSubreddits())
                        dismiss()
                    } label: {
                        HStack {
                            Text("Done")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                    .filledButton()
                case .userMultiSelection(_, let onConfirmSelection):
                    Button {
                        onConfirmSelection(subscriptionListingViewModel.getSelectedUsers())
                        dismiss()
                    } label: {
                        HStack {
                            Text("Done")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                    .filledButton()
                default:
                    EmptyView()
                }
            }
        }
        .task(id: subscriptionListingViewModel.subscriptionAndCustomFeedLoadingTaskFlag) {
            await subscriptionListingViewModel.loadSubscriptionsOnline()
            await subscriptionListingViewModel.loadMyCustomFeedsOnline()
        }
        .onAppear {
            if let key = navigationBarMenuKey {
                navigationBarMenuManager.pop(key: key)
            }
            navigationBarMenuKey = navigationBarMenuManager.push([
                NavigationBarMenuItem(title: "Refresh") {
                    subscriptionListingViewModel.refreshSubscriptions()
                },
                
                NavigationBarMenuItem(title: "Create Custom Feed") {
                    navigationManager.append(AppNavigation.createCustomFeed)
                }
            ])
        }
        .onDisappear {
            guard let navigationBarMenuKey else {
                return
            }
            navigationBarMenuManager.pop(key: navigationBarMenuKey)
        }
        .showErrorUsingSnackbar(subscriptionListingViewModel.$error)
    }
}
