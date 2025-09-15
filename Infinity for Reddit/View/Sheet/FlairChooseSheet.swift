//
// FlairChooseSheet.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-03

import SwiftUI

struct FlairChooseSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let flairs: [Flair]                 
    var onFlairSelected: (Flair) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if !flairs.isEmpty {
                    ForEach(flairs, id: \.id) { flair in
                        TouchRipple(action: {
                            onFlairSelected(flair)
                            dismiss()
                        }) {
                            HStack {
                                FlairRowView(
                                    flairRichtext: flair.richtext ?? [],
                                    flairText: flair.text
                                )
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    }
                } else {
                    Text("No flairs available")
                        .secondaryText()
                        .padding()
                }
            }
            .padding(.top, 20)
        }
    }
}

