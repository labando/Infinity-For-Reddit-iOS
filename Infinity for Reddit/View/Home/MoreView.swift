//
//  MoreView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-03.
//

import SwiftUI
import Swinject
import GRDB

struct MoreView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    NavigationLink(destination: HistoryView()) {
                    Text("History")
                    }
                }
                Section(header: Text("Post")) {
                    NavigationLink(destination: UpvotedView()) {
                    Text("Upvoted")
                }
                    NavigationLink(destination: DownvotedView()) {
                        Text("Downvoted")
                    }
                }
                Section(header: Text("Preferences")) {
                    NavigationLink(destination: UpvotedView()) {
                        Text("Settings")
                    }
                }
            }
            .navigationTitle("More")
        }
    }
}
