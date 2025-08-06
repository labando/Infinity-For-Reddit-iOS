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
                
                ForEach(commentFilterItemViewModel.commentFilterUsages.prefix(5), id: \.self) { commentFilterUsage in
                    RowText(commentFilterUsage.description)
                        .secondaryText()
                        .padding(.leading, 32)
                }
            }
            .contentShape(Rectangle())
            .padding(.leading, 72)
            .padding(.trailing, 16)
            .padding(.vertical, 16)
        }
    }
}
