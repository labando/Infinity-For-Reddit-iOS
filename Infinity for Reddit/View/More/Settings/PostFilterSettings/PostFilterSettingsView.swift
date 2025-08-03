//
// PostFilterSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB

struct PostFilterSettingsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var navigationBarMenuManager: NavigationBarMenuManager
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    @StateObject var postFilterViewModel: PostFilterViewModel
    @State private var navigationBarMenuKey: UUID?
    
    private let postFilterDao: PostFilterDao
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        postFilterDao = PostFilterDao(dbPool: resolvedDBPool)
        _postFilterViewModel = StateObject(
            wrappedValue: PostFilterViewModel(
                postFilterRepository: PostFilterRepository()
            )
        )
    }
    
    var body: some View {
        Group {
            if postFilterViewModel.postFilters.isEmpty {
                VStack(spacing: 0) {
                    InfoPreference(title: "Restart the app to see the changes", iconUrl: "info.circle")
                    
                    Divider()
                    
                    VStack(alignment: .center, spacing: 8) {
                        Spacer()
                        
                        SwiftUI.Image(systemName: "plus.circle")
                            .primaryIcon()
                        
                        Text("Start by creating a post filter")
                            .primaryIcon()
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        navigationManager.path.append(SettingsViewNavigation.createOrEditPostFilter())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    InfoPreference(title: "Restart the app to see the changes", iconUrl: "info.circle")
                        .listPlainItemNoInsets()
                    
                    Divider()
                        .listPlainItemNoInsets()
                    
                    ForEach(postFilterViewModel.postFilters, id: \.id) { filter in
                        TouchRipple(action: {
                            navigationManager.path.append(SettingsViewNavigation.createOrEditPostFilter(postFilter: filter))
                        }) {
                            VStack {
                                Text(filter.name)
                                    .primaryText()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(Rectangle())
                            .padding(16)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                postFilterViewModel.deletePostFilter(id: filter.id ?? -1)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .listPlainItemNoInsets()
                    }
                }
                .themedList()
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Post Filter")
        .toolbar {
            Button("", systemImage: "plus") {
                navigationManager.path.append(SettingsViewNavigation.createOrEditPostFilter())
            }
        }
    }
}

