//
//  PostFilterItemView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-05.
//

import SwiftUI

struct PostFilterItemView: View {
    @StateObject var postFilterItemViewModel: PostFilterItemViewModel
    
    let onPostFilterClicked: () -> Void
    
    init(postFilter: PostFilter, onPostFilterClicked: @escaping () -> Void) {
        _postFilterItemViewModel = StateObject(
            wrappedValue: .init(postFilter: postFilter)
        )
        self.onPostFilterClicked = onPostFilterClicked
    }
    
    var body: some View {
        TouchRipple(action: onPostFilterClicked) {
            VStack(spacing: 4) {
                RowText(postFilterItemViewModel.postFilter.name)
                    .primaryText()
                
                ForEach(postFilterItemViewModel.postFilterUsages.prefix(5), id: \.self) { postFilterUsage in
                    RowText(postFilterUsage.description)
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
