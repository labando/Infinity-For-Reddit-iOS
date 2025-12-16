//
//  UserSelectionSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-12-14.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct UserSelectionSheet: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var subscriptionListingViewModel: SubscriptionListingViewModel
    
    @State private var showSearchUsersSheet: Bool = false
    
    let onThingSelected: (Thing) -> Void
    
    init(onThingSelected: @escaping (Thing) -> Void) {
        _subscriptionListingViewModel = StateObject(
            wrappedValue: SubscriptionListingViewModel(
                // We don't care about the selection mode here cuz we are not using SubscriptionsView
                subscriptionSelectionMode: .noSelection,
                subscriptionListingRepository: SubscriptionListingRepository()
            )
        )
        self.onThingSelected = onThingSelected
    }

    var body: some View {
        SheetRootView {
            SubscribedUserListingView(
                subscriptionListingViewModel: subscriptionListingViewModel
            ) { subscribedUserData in
                onThingSelected(.subscribedUser(subscribedUserData))
                dismiss()
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Select a User")
        .task {
            await subscriptionListingViewModel.loadSubscriptionsOnline()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSearchUsersSheet = true
                } label: {
                    SwiftUI.Image(systemName: "magnifyingglass")
                }
            }
        }
        .sheet(isPresented: $showSearchUsersSheet) {
            NavigationStack {
                SearchUsersSheet { thing in
                    onThingSelected(thing)
                    dismiss()
                }
            }
        }
    }
}
