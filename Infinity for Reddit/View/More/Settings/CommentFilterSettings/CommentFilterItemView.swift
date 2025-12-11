//
//  CommentFilterItemView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

import SwiftUI

struct CommentFilterItemView: View {
    @StateObject var commentFilterItemViewModel: CommentFilterItemViewModel
    
    let onCommentFilterClicked: () -> Void
    
    init(commentFilter: CommentFilter, onCommentFilterClicked: @escaping () -> Void) {
        _commentFilterItemViewModel = StateObject(
            wrappedValue: .init(commentFilter: commentFilter)
        )
        self.onCommentFilterClicked = onCommentFilterClicked
    }
    
    var body: some View {
        TouchRipple(action: onCommentFilterClicked) {
            VStack(spacing: 4) {
                RowText(commentFilterItemViewModel.commentFilter.name)
                    .primaryText()
                
                if commentFilterItemViewModel.commentFilterUsages.isEmpty {
                    RowText("Applied to all subreddits")
                        .secondaryText()
                } else {
                    ForEach(commentFilterItemViewModel.commentFilterUsages.prefix(5), id: \.self) { commentFilterUsage in
                        RowText(commentFilterUsage.description)
                            .secondaryText()
                    }
                }
            }
            .contentShape(Rectangle())
            .padding(16)
        }
    }
}
