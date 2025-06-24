//
//  CommentListingViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-15.
//

import Foundation
import Combine
import MarkdownUI
import IdentifiedCollections

public class CommentListingViewModel: ObservableObject {
    // MARK: - Properties
    @Published var visibleComments: IdentifiedArrayOf<Comment> = []
    var allComments: IdentifiedArrayOf<Comment> = []
    @Published var isInitialLoad: Bool = true
    @Published var isInitialLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMorePages: Bool = true
    @Published var error: Error? = nil
    
    private var after: String? = nil
    public let commentListingRepository: CommentListingRepositoryProtocol
    private let commentListingMetadata: CommentListingMetadata
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(commentListingMetadata: CommentListingMetadata, commentListingRepository: CommentListingRepositoryProtocol) {
        self.commentListingMetadata = commentListingMetadata
        self.commentListingRepository = commentListingRepository
    }
    
    // MARK: - Methods
    
    public func initialLoadComments() async {
        guard isInitialLoad else {
            return
        }
        
        await loadComments()
    }
    
    /// Fetches the next page of comments
    public func loadComments() async {
        guard !isInitialLoading, !isLoadingMore, hasMorePages else { return }
        
        let isInitailLoadCopy = isInitialLoad
        
        await MainActor.run {
            if visibleComments.isEmpty {
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
            
            let commentListing = try await commentListingRepository.fetchComments(
                commentListingType: commentListingMetadata.commentListingType,
                pathComponents: commentListingMetadata.pathComponents,
                queries: ["limit": "100", "after": after ?? ""].merging(commentListingMetadata.queries ?? [:], uniquingKeysWith: { _, new in new }),
                params: commentListingMetadata.params)
            
            try Task.checkCancellation()
            
            let processedComments = self.postProcessComments(commentListing.comments)
            
            try Task.checkCancellation()
            
            await MainActor.run {
                if (processedComments.isEmpty) {
                    // No more comments
                    hasMorePages = false
                    self.after = nil
                } else {
                    self.after = commentListing.after
                    self.visibleComments.append(contentsOf: processedComments)
                    self.hasMorePages = !(processedComments.isEmpty || after == nil || after?.isEmpty == true)
                }
                
                printDuplicateCommentIDs(in: visibleComments)
                
                isInitialLoading = false
                isLoadingMore = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                
                isInitialLoad = isInitailLoadCopy
                isInitialLoading = false
                isLoadingMore = false
            }
            
            print("Error fetching comments: \(error)")
        }
    }
    
    func printDuplicateCommentIDs(in comments: IdentifiedArrayOf<Comment>) {
        var seen: Set<String> = []
        var duplicates: Set<String> = []

        for comment in comments {
            if !seen.insert(comment.id).inserted {
                duplicates.insert(comment.id)
            }
        }

        if duplicates.isEmpty {
            print("✅ No duplicate comment IDs found.")
        } else {
            print("❌ Duplicate comment IDs found:")
            for id in duplicates {
                print(" - \(id)")
            }
        }
    }
    
    /// Reloads posts from the first page
    func refreshComments() async {
        isInitialLoad = true
        isInitialLoading = false
        isLoadingMore = false
        
        after = nil
        hasMorePages = true
        visibleComments = []
        
        await initialLoadComments()
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
