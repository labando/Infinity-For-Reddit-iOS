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
                        SimpleTouchItemRow(
                            text: flair.text,
                            icon: nil
                        ){
                            onFlairSelected(flair)
                            dismiss()
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

