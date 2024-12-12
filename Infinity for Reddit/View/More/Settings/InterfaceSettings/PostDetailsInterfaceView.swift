//
//  PostDetailsInterfaceView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-11.
//

import Swinject
import GRDB
import SwiftUI

struct PostDetailInterfaceView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @State private var separatePostAndCommentsInLandscapeMode: Bool
    @State private var hidePostType: Bool
    @State private var hidePostFlair: Bool
    @State private var hideUpvoteRatio: Bool
    @State private var hideSubredditAndUserPrefix: Bool
    @State private var hideNumberOfVotes: Bool
    @State private var hideNumberOfComments: Bool
    @State private var embeddedMediaType: Int
    
    let SEPARATE_POST_AND_COMMENTS_IN_LANDSCAPE_MODE = UserDefaultsUtils.SEPARATE_POST_AND_COMMENTS_IN_LANDSCAPE_MODE
    let HIDE_POST_TYPE = UserDefaultsUtils.HIDE_POST_TYPE
    let HIDE_POST_FLAIR = UserDefaultsUtils.HIDE_POST_FLAIR
    let HIDE_UPVOTE_RATIO = UserDefaultsUtils.HIDE_UPVOTE_RATIO
    let HIDE_SUBREDDIT_AND_USER_PREFIX = UserDefaultsUtils.HIDE_SUBREDDIT_AND_USER_PREFIX
    let HIDE_NUMBER_OF_VOTES = UserDefaultsUtils.HIDE_THE_NUMBER_OF_VOTES
    let HIDE_NUMBER_OF_COMMENTS = UserDefaultsUtils.HIDE_THE_NUMBER_OF_COMMENTS
    let EMBEDDED_MEDIA_TYPE = UserDefaultsUtils.EMBEDDED_MEDIA_TYPE
    
    private let embeddedMediaTypes: [String] = ["All", "Image and GIF", "Image and emote", "GIF and emote", "Image", "GIF", "Emote", "None"]
    private let userDefaults: UserDefaults
    
    init() {
        guard let resolvedUserDefaults = DependencyManager.shared.container.resolve(UserDefaults.self) else {
            fatalError("Failed to resolve UserDefaults")
        }
        self.userDefaults = resolvedUserDefaults
        
        if userDefaults.object(forKey: SEPARATE_POST_AND_COMMENTS_IN_LANDSCAPE_MODE) == nil {
            userDefaults.set(true, forKey: SEPARATE_POST_AND_COMMENTS_IN_LANDSCAPE_MODE)
        }
        if userDefaults.object(forKey: HIDE_POST_TYPE) == nil {
            userDefaults.set(false, forKey: HIDE_POST_TYPE)
        }
        if userDefaults.object(forKey: HIDE_POST_FLAIR) == nil {
            userDefaults.set(false, forKey: HIDE_POST_FLAIR)
        }
        if userDefaults.object(forKey: HIDE_UPVOTE_RATIO) == nil {
            userDefaults.set(false, forKey: HIDE_UPVOTE_RATIO)
        }
        if userDefaults.object(forKey: HIDE_SUBREDDIT_AND_USER_PREFIX) == nil {
            userDefaults.set(false, forKey: HIDE_SUBREDDIT_AND_USER_PREFIX)
        }
        if userDefaults.object(forKey: HIDE_NUMBER_OF_VOTES) == nil {
            userDefaults.set(false, forKey: HIDE_NUMBER_OF_VOTES)
        }
        if userDefaults.object(forKey: HIDE_NUMBER_OF_COMMENTS) == nil {
            userDefaults.set(false, forKey: HIDE_NUMBER_OF_COMMENTS)
        }
        if userDefaults.object(forKey: EMBEDDED_MEDIA_TYPE) == nil {
            userDefaults.set(0, forKey: EMBEDDED_MEDIA_TYPE)
        }
        
        _separatePostAndCommentsInLandscapeMode = State(initialValue: userDefaults.bool(forKey: SEPARATE_POST_AND_COMMENTS_IN_LANDSCAPE_MODE))
        _hidePostType = State(initialValue: userDefaults.bool(forKey: HIDE_POST_TYPE))
        _hidePostFlair = State(initialValue: userDefaults.bool(forKey: HIDE_POST_FLAIR))
        _hideUpvoteRatio = State(initialValue: userDefaults.bool(forKey: HIDE_UPVOTE_RATIO))
        _hideSubredditAndUserPrefix = State(initialValue: userDefaults.bool(forKey: HIDE_SUBREDDIT_AND_USER_PREFIX))
        _hideNumberOfVotes = State(initialValue: userDefaults.bool(forKey: HIDE_NUMBER_OF_VOTES))
        _hideNumberOfComments = State(initialValue: userDefaults.bool(forKey: HIDE_NUMBER_OF_COMMENTS))
        _embeddedMediaType = State(initialValue: userDefaults.integer(forKey: EMBEDDED_MEDIA_TYPE))
    }
    
    var body: some View {
        List {
            Toggle(isOn: $separatePostAndCommentsInLandscapeMode){
                VStack(alignment: .leading) {
                    Text("Separate Post And Comments in Landscape Mode")
                    Text("Video autoplay will be disabled in the post detail page")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 44.5)
            .onChange(of: separatePostAndCommentsInLandscapeMode) { _, newValue in
                userDefaults.set(newValue, forKey: SEPARATE_POST_AND_COMMENTS_IN_LANDSCAPE_MODE)
            }
            
            Toggle("Hide Post Type", isOn: $hidePostType)
                .padding(.leading, 44.5)
                .onChange(of: hidePostType) { _, newValue in
                    userDefaults.set(newValue, forKey: HIDE_POST_TYPE)
                }
            Toggle("Hide Post Flair", isOn: $hidePostFlair)
                .padding(.leading, 44.5)
                .onChange(of: hidePostFlair) { _, newValue in
                    userDefaults.set(newValue, forKey: HIDE_POST_FLAIR)
                }
            Toggle("Hide Upvote Ratio", isOn: $hideUpvoteRatio)
                .padding(.leading, 44.5)
                .onChange(of: hideUpvoteRatio) { _, newValue in
                    userDefaults.set(newValue, forKey: HIDE_UPVOTE_RATIO)
                }
            Toggle("Hide Subreddit and User Prefix", isOn: $hideSubredditAndUserPrefix)
                .padding(.leading, 44.5)
                .onChange(of: hideSubredditAndUserPrefix) { _, newValue in
                    userDefaults.set(newValue, forKey: HIDE_SUBREDDIT_AND_USER_PREFIX)
                }
            Toggle("Hide the Number of Votes", isOn: $hideNumberOfVotes)
                .padding(.leading, 44.5)
                .onChange(of: hideNumberOfVotes) { _, newValue in
                    userDefaults.set(newValue, forKey: HIDE_NUMBER_OF_VOTES)
                }
            Toggle("Hide the Number of Comments", isOn: $hideNumberOfComments)
                .padding(.leading, 44.5)
                .onChange(of: hideNumberOfComments) { _, newValue in
                    userDefaults.set(newValue, forKey: HIDE_NUMBER_OF_COMMENTS)
                }
            Picker("Embedded Media Type", selection: $embeddedMediaType) {
                ForEach(0..<embeddedMediaTypes.count, id: \.self) { index in
                    Text(embeddedMediaTypes[index]).tag(index)
                }
            }
            .padding(.leading, 44.5)
            .onChange(of: embeddedMediaType) { _, newValue in
                userDefaults.set(newValue, forKey: EMBEDDED_MEDIA_TYPE)
            }
        }
        .navigationTitle("Post Details")
    }
}
