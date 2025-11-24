//
// SubredditRulesView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-27

import SwiftUI
import MarkdownUI

struct SubredditRulesView: View {
    @EnvironmentObject private var subredditChooseViewModel: PostSubmissionContextViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(subredditChooseViewModel.rules, id: \.shortName) { rule in
                    Markdown(rule.shortName)
                        .markdownTextStyle {
                            FontSize(16)
                        }
                        .themedMarkdown()
                        .padding(.vertical, 22)
                    
                    Markdown(rule.description)
                        .markdownTextStyle {
                            FontSize(14)
                        }
                        .themedMarkdown()
                }
            }
        }
        .padding(.horizontal, 12)
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Rules")
    }
}
