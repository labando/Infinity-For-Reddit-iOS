//
//  AppNavigation.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-04-03.
//

enum AppNavigation: Hashable {
    case login
    case postDetails(postDetailsInput: PostDetailsInput, isFromSubredditPostListing: Bool)
    case postDetailsWithId(postId: String, commentId: String?, isContinueThread: Bool = false)
    case subredditDetails(subredditName: String)
    case userDetails(username: String)
    case search(query: String, searchInSubredditOrUserName: String?, searchInMultiReddit: String?, searchInThingType: Int)
    case customFeed(myCustomFeed: MyCustomFeed)
    case inboxConversation(inbox: Inbox)
    case submitComment(commentParent: CommentParent)
    case submitTextPost(resetSelectedSubreddit: Bool)
    case submitLinkPost(resetSelectedSubreddit: Bool)
    case submitImagePost
    case submitVideoPost
    case submitGalleryPost
    case submitPollPost
    case chooseSubredditForNewPost
    case filterPosts(postListingMetadata: PostListingMetadata)
    case filteredPosts(postListingMetadata: PostListingMetadata, postFilter: PostFilter)
    case searchSubreddits(query: String, searchInSubredditOrUserName: String?, searchInMultiReddit: String?, searchInThingType: Int)
    case subredditSearch(username: String)
}
