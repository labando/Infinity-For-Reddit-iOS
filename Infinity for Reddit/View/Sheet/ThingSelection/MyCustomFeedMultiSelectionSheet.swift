//
//  MyCustomFeedMultiSelectionSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-12-14.
//

import SwiftUI

struct MyCustomFeedMultiSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var subscriptionListingViewModel: SubscriptionListingViewModel
    
    var onSelectMyCustomFeeds: ([Thing]) -> Void
    
    init(onSelectMyCustomFeeds: @escaping ([Thing]) -> Void) {
        _subscriptionListingViewModel = StateObject(
            wrappedValue: SubscriptionListingViewModel(
                // We don't care about the selection mode here cuz we are not using SubscriptionsView
                subscriptionSelectionMode: .noSelection,
                subscriptionListingRepository: SubscriptionListingRepository()
            )
        )
        self.onSelectMyCustomFeeds = onSelectMyCustomFeeds
    }
    
    var body: some View {
        SheetRootView {
            VStack(spacing: 0) {
                MyCustomFeedListingMultiSelectionView(subscriptionListingViewModel: subscriptionListingViewModel)
                
                Button {
                    onSelectMyCustomFeeds(subscriptionListingViewModel.getSelectedMyCustomFeeds())
                    dismiss()
                } label: {
                    HStack {
                        Text("Done")
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(16)
                .filledButton()
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Custom Feeds")
    }
}
