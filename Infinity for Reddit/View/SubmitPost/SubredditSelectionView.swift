
//
// SubredditSelectionView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI
import Swinject
import GRDB
import Alamofire

struct SubredditSelectionView: View {
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
            SubredditsView(subscriptionListingViewModel: subscriptionListingViewModel)
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Select a Subreddit")
        .task {
            await subscriptionListingViewModel.loadSubscriptionsOnline()
            await subscriptionListingViewModel.loadMyCustomFeedsOnline()
        }
    }
    
    struct SubredditsView: View {
        @EnvironmentObject var navigationManager: NavigationManager
        @ObservedObject var subscriptionListingViewModel: SubscriptionListingViewModel
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var subredditChooseViewModel: SubredditChooseViewModel
        
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
                        if !subscriptionListingViewModel.favoriteSubredditSubscriptions.isEmpty {
                            Section(header: Text("Favorite").listSectionHeader()) {
                                ForEach(subscriptionListingViewModel.favoriteSubredditSubscriptions, id: \.identityInView) { subscription in
                                    SubscriptionItemView(text: subscription.name, iconUrl: subscription.iconUrl, isFavorite: subscription.isFavorite, action: {
                                        subredditChooseViewModel.selectedSubreddit = subscription
                                        dismiss()
                                    }){
                                        subscription.isFavorite.toggle()
                                        Task {
                                            await subscriptionListingViewModel.toggleFavoriteSubreddit(subscription)
                                        }
                                    }
                                    .listPlainItemNoInsets()
                                }
                            }
                            .listPlainItem()
                        }
                        
                        Section(header: Text("All").listSectionHeader()) {
                            ForEach(subscriptionListingViewModel.subredditSubscriptions, id: \.identityInView) { subscription in
                                SubscriptionItemView(text: subscription.name, iconUrl: subscription.iconUrl, isFavorite: subscription.isFavorite, action: {
                                    subredditChooseViewModel.selectedSubreddit = subscription
                                    dismiss()
                                }) {
                                    subscription.isFavorite.toggle()
                                    Task {
                                        await subscriptionListingViewModel.toggleFavoriteSubreddit(subscription)
                                    }
                                }
                                .listPlainItemNoInsets()
                            }
                        }
                        .listPlainItem()
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .themedList()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        SwiftUI.Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }
}

