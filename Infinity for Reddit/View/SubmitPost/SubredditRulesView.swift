//
// SubredditRulesView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-27

import SwiftUI
import MarkdownUI

struct SubredditRulesView: View {
    @EnvironmentObject private var subredditChooseViewModel: SubredditChooseViewModel

    var body: some View {
        Group {
            if !subredditChooseViewModel.rules.isEmpty {
                VStack {
                    ForEach(subredditChooseViewModel.rules, id: \.id) { rule in
                        Text(rule.shortName)
                        Markdown(rule.descriptionHtml)
                            .themedMarkdown()
                    }
                }
            } else {
                Text("No rules")
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Rules")
    }
}
