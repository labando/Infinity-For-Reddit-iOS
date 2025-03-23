//
//  PostDetailsView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-23.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct PostDetailsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    @StateObject var postListingViewModel: PostListingViewModel
    private let account: Account
    
    init(account: Account, postListingMetadata: PostListingMetadata) {
        self.account = account
        
        _postListingViewModel = StateObject(
            wrappedValue: PostListingViewModel(
                account: account,
                postListingMetadata: postListingMetadata,
                postListingRepository: PostListingRepository()
            )
        )
    }
    
    var body: some View {
        Group {
            if postListingViewModel.isInitialLoading {
                Text("Is loading")
            } else if postListingViewModel.posts.isEmpty {
                Text("No posts")
            } else {
                List {
                    ForEach(postListingViewModel.posts, id: \.id) { post in
                        PostViewCard(account: account, post: post)
                            .id(post.id)
                    }
                    if postListingViewModel.hasMorePages {
                        Text("Loading more pages")
                            .onAppear {
                                postListingViewModel.loadPosts()
                            }
                    }
                }.scrollBounceBehavior(.basedOnSize)
            }
        }
        .onChange(of: colorScheme) {
            //print(colorScheme == .dark)
        }
        .onAppear {
            postListingViewModel.loadPosts()
        }
        .themedList()
    }
}
