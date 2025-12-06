//
// SubredditRulesView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-27

import SwiftUI
import MarkdownUI

struct SubredditRulesSheet: View {
    @EnvironmentObject private var postSubmissionContextViewModel: PostSubmissionContextViewModel
    
    var body: some View {
        Group {
            if postSubmissionContextViewModel.rules.isEmpty {
                ZStack {
                    if postSubmissionContextViewModel.isLoadingRules {
                        ProgressIndicator()
                    } else if let error = postSubmissionContextViewModel.rulesError {
                        Text("Unable to load rules. Tap to retry. Error: \(error.localizedDescription)")
                            .primaryText()
                            .padding(16)
                            .onTapGesture {
                                postSubmissionContextViewModel.fetchRules()
                            }
                    } else {
                        Text("No subreddit-specific rules.")
                            .primaryText()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(postSubmissionContextViewModel.rules, id: \.shortName) { rule in
                            Markdown(rule.shortName)
                                .markdownTextStyle {
                                    FontSize(16)
                                }
                                .themedMarkdown()
                                .padding(.vertical, 16)
                            
                            Spacer()
                                .frame(height: 8)
                            
                            Markdown(rule.description)
                                .markdownTextStyle {
                                    FontSize(14)
                                }
                                .themedMarkdown()
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .onAppear {
            postSubmissionContextViewModel.fetchRules()
        }
    }
}
