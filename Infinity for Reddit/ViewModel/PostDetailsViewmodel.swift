//
//  PostDetailsViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-23.
//

import Foundation
import Combine
import MarkdownUI

public class PostDetailsViewModel: ObservableObject {
    // MARK: - Properties
    @Published var post: Post
    @Published var comments: [Comment] = []
    @Published var isSingleThread: Bool =  false
    @Published var isInitialLoad: Bool = true
    @Published var isInitialLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMoreComments: Bool = true
    @Published var error: Error?
    private let account: Account
    private var postId: String?
    private var commentMore: CommentMore?
    
    private var after: String? = nil
    
    public let postDetailsRepository: PostDetailsRepositoryProtocol
    
    // MARK: - Initializer
    init(account: Account, post: Post, postDetailsRepository: PostDetailsRepositoryProtocol) {
        self.account = account
        self.post = post
        self.postDetailsRepository = postDetailsRepository
    }
    
    // MARK: - Methods
    
    public func fetchComments() async {
        guard !isInitialLoading, !isLoadingMore, hasMoreComments else { return }
        
        let isInitailLoadCopy = isInitialLoad
        
        await MainActor.run {
            if comments.isEmpty {
                isInitialLoading = true
            } else {
                isLoadingMore = true
            }
            
            if isInitialLoad {
                isInitialLoad = false
            }
        }
        
        do {
            try Task.checkCancellation()
            
            let postDetails = try await postDetailsRepository.fetchComments(
                postId: post.id,
                queries: ["after": after ?? ""]
            )
            
            try Task.checkCancellation()
            
            let processedComments = postProcessComments(postDetails.comments)
            
            try Task.checkCancellation()
            
            await MainActor.run {
                self.comments.append(contentsOf: processedComments)
                
                hasMoreComments = postDetails.commentListing.commentMore?.children.isEmpty == false
                
                self.isInitialLoading = false
                self.isLoadingMore = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                
                self.isInitialLoad = isInitailLoadCopy
                self.isInitialLoading = false
                self.isLoadingMore = false
            }
            print("Error fetching comments: \(error)")
        }
    }
    
    /// Reloads posts from the first page
    func refreshPosts() async {
        await MainActor.run {
            isInitialLoad = true
            isInitialLoading = false
            isLoadingMore = false
            
            after = nil
            hasMoreComments = true
            comments = []
        }
        
        await fetchComments()
    }
    
    func postProcessComments(_ comments: [Comment]) -> [Comment] {
        return comments.map {
            modifyCommentBody($0)
            $0.bodyProcessedMarkdown = MarkdownContent($0.body)
            return $0
        }
    }
    
    func modifyCommentBody(_ comment: Comment) {
        MarkdownUtils.parseRedditImagesBlock(comment)
    }
}
