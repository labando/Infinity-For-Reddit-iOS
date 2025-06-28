//
//  CommentMoreViewCard.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-28.
//

import SwiftUI

struct CommentMoreViewCard: View {
    let commentMore: CommentMore
    
    var body: some View {
        HStack(spacing: 0) {
            CommentIndentationView(depth: commentMore.depth)
            
            Spacer()
            
            Text("Load more comments")
                .commentText()
                .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}
