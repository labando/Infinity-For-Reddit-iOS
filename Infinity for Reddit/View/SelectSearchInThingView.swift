//
//  SelectSearchInThingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

import SwiftUI

struct SelectSearchInThingView: View {
    @EnvironmentObject private var accountViewModel: AccountViewModel
    
    let onSelectThing: (SearchInThing) -> Void
    
    var body: some View {
        Group {
            if accountViewModel.account.isAnonymous() {
                AnonymousSubscriptionsView() { searchInThing in
                    
                }
                    .setUpHomeTabViewChildNavigationBar()
            } else {
                SubscriptionsView()
                    .setUpHomeTabViewChildNavigationBar()
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Select")
    }
}
