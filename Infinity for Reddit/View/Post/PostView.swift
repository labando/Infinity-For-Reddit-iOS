//
// PostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-11-01

import SwiftUI

struct PostView: View {
    @EnvironmentObject private var accountViewModel: AccountViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @StateObject private var postViewModel: PostViewModel
    
    let post: Post
    let postLayout: PostLayout
    let isSubredditPostListing: Bool
    let onPostTypeTap: () -> Void
    let onSensitiveTap: () -> Void
    let onLongPressPost: () -> Void
    let onShare: () -> Void

    init(
        post: Post,
        postLayout: PostLayout,
        isSubredditPostListing: Bool,
        onPostTypeTap: @escaping () -> Void,
        onSensitiveTap: @escaping () -> Void,
        onLongPressPost: @escaping () -> Void,
        onShare: @escaping () -> Void
    ) {
        self.post = post
        self.postLayout = postLayout
        self.isSubredditPostListing = isSubredditPostListing
        self.onPostTypeTap = onPostTypeTap
        self.onSensitiveTap = onSensitiveTap
        self.onLongPressPost = onLongPressPost
        self.onShare = onShare
        _postViewModel = StateObject(
            wrappedValue: PostViewModel(
                account: AccountViewModel.shared.account,
                post: post,
                postRepository: PostRepository()
            )
        )
    }

    var body: some View {
        Group {
            switch postLayout {
            case .card:
                PostViewCard(
                    postViewModel: postViewModel,
                    isSubredditPostListing: isSubredditPostListing,
                    onPostTap: onPostTap,
                    onIconTap: onIconTap,
                    onSubredditTap: onSubredditTap,
                    onUserTap: onUserTap,
                    onVote: vote,
                    onCommentsTap: onCommentsTap,
                    onSave: savePost,
                    onPostTypeClicked: onPostTypeTap,
                    onSensitiveClicked: onSensitiveTap,
                    onOpenLink: openLink,
                    onShare: onShare
                )
            case .compact:
                PostViewCompact(
                    postViewModel: postViewModel,
                    isSubredditPostListing: isSubredditPostListing,
                    onPostTap: onPostTap,
                    onIconTap: onIconTap,
                    onSubredditTap: onSubredditTap,
                    onUserTap: onUserTap,
                    onVote: vote,
                    onCommentsTap: onCommentsTap,
                    onSave: savePost,
                    onPostTypeClicked: onPostTypeTap,
                    onSensitiveClicked: onSensitiveTap,
                    onOpenLink: openLink,
                    onShare: onShare
                )
            }
        }
        .onLongPressGesture {
            onLongPressPost()
        }
    }
    
    private func onPostTap() {
        Task {
            await postViewModel.readPost()
        }
        
        navigationManager.append(
            AppNavigation.postDetails(
                postDetailsInput: .post(post),
                isFromSubredditPostListing: isSubredditPostListing
            )
        )
    }
    
    private func onIconTap() {
        if !isSubredditPostListing {
            navigationManager.append(
                AppNavigation.subredditDetails(subredditName: post.subreddit)
            )
        } else if !post.isAuthorDeleted() {
            navigationManager.append(
                AppNavigation.userDetails(username: post.author)
            )
        }
    }
    
    private func onSubredditTap() {
        navigationManager.append(
            AppNavigation.subredditDetails(subredditName: post.subreddit)
        )
    }
    
    private func onUserTap() {
        navigationManager.append(
            AppNavigation.userDetails(username: post.author)
        )
    }
    
    private func vote(_ direction: Int) {
        guard !accountViewModel.account.isAnonymous() else { return }
        Task {
            await postViewModel.votePost(vote: direction)
        }
    }
    
    private func savePost() {
        Task {
            await postViewModel.savePost(save: !postViewModel.post.saved)
        }
    }
    
    private func onCommentsTap() {
        // TODO: Open post details and focus on comments section.
    }
    
    private func openLink(_ url: URL) {
        navigationManager.openLink(url)
        Task {
            await postViewModel.readPost()
        }
    }
}
