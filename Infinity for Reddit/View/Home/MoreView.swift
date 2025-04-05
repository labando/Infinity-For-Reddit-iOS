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
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    var body: some View {
        List {
            Section(header: Text("Account").listSectionHeader()) {
                RowText("Profile")
                    .primaryText()
                    .onTapGesture {
                        navigationManager.path.append(MoreViewNavigation.profile)
                    }
                
                RowText("History")
                    .primaryText()
                    .onTapGesture {
                        navigationManager.path.append(MoreViewNavigation.history)
                    }
            }
            .listPlainItem()
            
            Section(header: Text("Post").listSectionHeader()) {
                RowText("Upvoted")
                    .primaryText()
                    .onTapGesture {
                        navigationManager.path.append(MoreViewNavigation.upvoted)
                    }
                
                RowText("Downvoted")
                    .primaryText()
                    .onTapGesture {
                        navigationManager.path.append(MoreViewNavigation.downvoted)
                    }
                
                RowText("Hidden")
                    .primaryText()
                    .onTapGesture {
                        navigationManager.path.append(MoreViewNavigation.hidden)
                    }
                
                RowText("Saved")
                    .primaryText()
                    .onTapGesture {
                        navigationManager.path.append(MoreViewNavigation.saved)
                    }
            }
            .listPlainItem()
            
            Section(header: Text("Preferences").listSectionHeader()) {
                RowText("Settings")
                    .primaryText()
                    .onTapGesture {
                        navigationManager.path.append(MoreViewNavigation.settings)
                    }
                
                RowText("Test")
                    .primaryText()
                    .onTapGesture {
                        navigationManager.path.append(MoreViewNavigation.test)
                    }
            }
            .listPlainItem()
        }
        .themedList()
    }
}
