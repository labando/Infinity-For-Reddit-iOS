//
//  TestView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI

struct TestView: View {
    @State private var selectedItem: Tab1? = nil
    private let tabs = [Tab1.home, Tab1.subscriptions]
    
    var body: some View {
        List {
            ForEach(tabs, id: \.self) { tab in
                NavigationLink(destination: tab.link, tag: tab, selection: self.$selectedItem) {
                    Text("Interface")
                        .primaryText()
                }
                .listRowBackground(self.selectedItem == tab ? Color.gray : Color.clear)
                //.listPlainItem()
            }
//            NavigationLink(destination: NotificationSettingsView()) {
//                Text("Notification")
//                    .primaryText()
//            }
//            .listPlainItem()
//            .buttonStyle(NavigationLinkButtonStyle())
//            .listRowBackground(Color.clear)
        }
        .themedList()
        .listItemTint(Color.clear)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                            Button("About") {
                                print("About tapped!")
                            }

                            Button("Help") {
                                print("Help tapped!")
                            }
                        }

                        ToolbarItemGroup(placement: .secondaryAction) {
                            Button("Settings") {
                                print("Credits tapped")
                            }

                            Button("Email Me") {
                                print("Email tapped")
                            }
                        }
        }
        .navigationTitle("Settings")
    }
}

enum Tab1 {
    case home, subscriptions
    
    var link: some View {
        switch self {
        case .home: return NotificationSettingsView()
        case .subscriptions: return InterfaceSettingsView()
        }
    }
}
