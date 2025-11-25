//
//  WikiView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-25.
//

import SwiftUI
import MarkdownUI

struct WikiView: View {
    @StateObject var wikiViewModel: WikiViewModel
    
    init(subredditName: String, wikiPath: String = "index") {
        _wikiViewModel = StateObject(wrappedValue: WikiViewModel(
            subedditName: subredditName,
            wikiPath: wikiPath,
            wikiRepository: WikiRepository()
        ))
    }
    
    var body: some View {
        RootView {
            if let wiki = wikiViewModel.wiki {
                ScrollView {
                    if wiki.isEmpty {
                        Text("No wiki found")
                            .primaryText()
                    } else {
                        Markdown(wiki)
                            .themedMarkdown()
                    }
                }
            } else {
                if let error = wikiViewModel.error {
                    ZStack {
                        Text("Failed to load wiki: \(error.localizedDescription). Tap to retry")
                            .primaryText()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        wikiViewModel.wikiTaskTrigger.toggle()
                    }
                } else {
                    ZStack {
                        ProgressIndicator()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }   
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Wiki")
        .task(id: wikiViewModel.wikiTaskTrigger) {
            await wikiViewModel.fetchWiki()
        }
    }
}
