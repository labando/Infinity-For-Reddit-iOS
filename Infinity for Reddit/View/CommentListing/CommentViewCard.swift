//
//  CommentViewCard.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-17.
//

import SwiftUI
import SDWebImageSwiftUI
import MarkdownUI

struct CommentViewCard: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject var commentViewModel: CommentViewModel
    @State private var voteTask: Task<Void, Never>? = nil
    @State private var saveTask: Task<Void, Never>? = nil
    
    let formatter = DateFormatter()
    private let isInPostDetails: Bool
    
    init(account: Account, comment: Comment, isInPostDetails: Bool) {
        formatter.dateFormat = "y-MM-dd H:mm"
        self.isInPostDetails = isInPostDetails
        _commentViewModel = StateObject(wrappedValue: CommentViewModel(account: account, comment: comment, commentRepository: CommentRepository()))
    }
    
    var body: some View {
        HStack(spacing: 0) {
            CommentIndentationView(depth: commentViewModel.comment.depth)
            
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    CustomWebImage(
                        commentViewModel.comment.authorIconUrl?.absoluteString,
                        width: 24,
                        height: 24,
                        circleClipped: true,
                        handleImageTapGesture: false,
                        fallbackView: {
                            SwiftUI.Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    )
                    .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading) {
                        if !isInPostDetails {
                            Text(commentViewModel.comment.subredditNamePrefixed)
                                .subreddit()
                                .onTapGesture {
                                    navigationManager.path.append(AppNavigation.subredditDetails(subredditName: commentViewModel.comment.subreddit))
                                }
                        }
                        
                        Text("u/\(commentViewModel.comment.author)")
                            .username()
                            .onTapGesture {
                                navigationManager.path.append(AppNavigation.userDetails(username: commentViewModel.comment.author))
                            }
                    }
                    
                    Spacer()
                    
                    Text(
                        formatter.string(from: Date(timeIntervalSince1970: TimeInterval(commentViewModel.comment.createdUtc)))
                    )
                    .secondaryText()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                
                Group {
                    if commentViewModel.comment.bodyProcessedMarkdown != nil {
                        Markdown(commentViewModel.comment.bodyProcessedMarkdown!)
                            .markdownImageProvider(WebImageProvider(mediaMetadata: commentViewModel.comment.mediaMetadata))
                            .font(.system(size: 24))
                            .padding(.horizontal, 16)
                            .themedCommentMarkdown()
                            .id(commentViewModel.comment.id)
                    } else {
                        Markdown(commentViewModel.comment.body)
                            .markdownImageProvider(WebImageProvider(mediaMetadata: commentViewModel.comment.mediaMetadata))
                            .font(.system(size: 24))
                            .padding(.horizontal, 16)
                            .themedCommentMarkdown()
                            .id(commentViewModel.comment.id)
                    }
                }
                
                HStack(alignment: .center) {
                    Button(action: {
                        voteTask?.cancel()
                        voteTask = Task {
                            await commentViewModel.voteComment(vote: 1)
                        }
                    }) {
                        SwiftUI.Image(commentViewModel.comment.likes == 1 ? "upvoted" : "upvote")
                            .commentIconTemplateRendering()
                            .commentUpvoteIcon(isUpvoted: commentViewModel.comment.likes == 1)
                    }
                    .buttonStyle(.borderless)
                    
                    Text(String(commentViewModel.comment.score + commentViewModel.comment.likes))
                        .frame(width: 50, alignment: .center)
                        .commentInfo()
                    
                    Button(action: {
                        voteTask?.cancel()
                        voteTask = Task {
                            await commentViewModel.voteComment(vote: -1)
                        }
                    }) {
                        SwiftUI.Image(commentViewModel.comment.likes == -1 ? "downvoted" : "downvote")
                            .commentIconTemplateRendering()
                            .commentDownvoteIcon(isDownvoted: commentViewModel.comment.likes == -1)
                    }
                    .padding(.trailing, 16)
                    .buttonStyle(.borderless)
                    
                    Spacer()
                    
                    Button(action: {
                        saveTask?.cancel()
                        saveTask = Task {
                            await commentViewModel.saveComment(save: !commentViewModel.comment.saved)
                        }
                    }) {
                        SwiftUI.Image(systemName: commentViewModel.comment.saved ? "bookmark.fill" : "bookmark")
                            .commentIconTemplateRendering()
                            .commentIcon()
                    }
                    .padding(.trailing, 16)
                    .buttonStyle(.borderless)
                    
                    ShareLink(item: "https://reddit.com" + commentViewModel.comment.permalink) {
                        SwiftUI.Image(systemName: "square.and.arrow.up")
                            .commentIconTemplateRendering()
                            .commentIcon()
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
            }
        }
    }
}
