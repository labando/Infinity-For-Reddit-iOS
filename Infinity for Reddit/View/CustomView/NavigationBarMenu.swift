//
//  NavigationBarMenu.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-01.
//

import SwiftUI

struct NavigationBarMenu: View {
    @EnvironmentObject var navigationBarMenuManager: NavigationBarMenuManager
    
    var body: some View {
        if navigationBarMenuManager.items.isEmpty {
            EmptyView()
        } else {
            Menu {
                ForEach(navigationBarMenuManager.items) { item in
                    Button(item.title, action: item.action)
                }
            } label: {
                SwiftUI.Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
            }
        }
    }
}
