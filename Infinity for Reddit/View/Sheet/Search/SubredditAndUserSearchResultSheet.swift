//
//  SubredditAndUserSearchResultSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

import SwiftUI

struct SubredditAndUserSearchResultSheet: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var subredditListingViewModel: SubredditListingViewModel
    @StateObject private var userListingViewModel: UserListingViewModel
    
    @State private var selectedOption = 0
    
    let query: String
    
    init(query: String, onSearchInThingSelected: @escaping (Thing) -> Void) {
        self.query = query
        _subredditListingViewModel = StateObject(
            wrappedValue: SubredditListingViewModel(
                query: query,
                thingSelectionMode: .thingSelection(onSelectThing: { thing in
                    onSearchInThingSelected(thing)
                }),
                subredditListingRepository: SubredditListingRepository()
            )
        )
        _userListingViewModel = StateObject(
            wrappedValue: UserListingViewModel(
                query: query,
                thingSelectionMode: .thingSelection(onSelectThing: { thing in
                    onSearchInThingSelected(thing)
                }),
                userListingRepository: UserListingRepository()
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SegmentedPicker(selectedValue: $selectedOption, values: ["Subreddits", "Users"])
                .padding(4)
            
            TabView(selection: $selectedOption) {
                SubredditListingView(account: accountViewModel.account, subredditListingViewModel: subredditListingViewModel)
                    .tag(0)
                
                UserListingView(account: accountViewModel.account, userListingViewModel: userListingViewModel)
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .id(accountViewModel.account.username)
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Select a Destination")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .navigationBarPrimaryText()
                }
            }
        }
    }
}
