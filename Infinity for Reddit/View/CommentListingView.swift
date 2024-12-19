//
//  CommentListingView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-15.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct CommentListingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @StateObject var commentListingViewModel: CommentListingViewModel
    
    init(commentListingMetadata: CommentListingMetadata) {
        // Resolve the session ASAP and store it in a property
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        
        _commentListingViewModel = StateObject(
            wrappedValue: CommentListingViewModel(
                commentListingMetadata: commentListingMetadata,
                commentListingRepository: CommentListingRepository(
                    session: resolvedSession
                )
            )
        )
    }
    
    var body: some View {
        Group {
            if commentListingViewModel.isInitialLoading {
                Text("Is loading")
            } else if commentListingViewModel.comments.isEmpty {
                Text("No Comments")
            } else {
                List {
                    ForEach(commentListingViewModel.comments, id: \.id) { comment in
                        CommentViewCard(account: accountViewModel.account, comment: comment)
                            .id(comment.id)
                    }
                    if commentListingViewModel.hasMorePages {
                        Text("Loading more pages")
                            .onAppear {
                                commentListingViewModel.loadComments(account: accountViewModel.account)
                            }
                    }
                }.scrollBounceBehavior(.basedOnSize)
            }
        }
        .onChange(of: colorScheme) {
            //print(colorScheme == .dark)
        }
        .onAppear {
            commentListingViewModel.loadComments(account: accountViewModel.account)
        }
        .listStyle(.plain)
        
    }
    
}

