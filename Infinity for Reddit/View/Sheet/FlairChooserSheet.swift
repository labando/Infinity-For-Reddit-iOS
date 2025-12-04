//
// FlairChooserSheet.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-03

import SwiftUI

struct FlairChooserSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var postSubmissionContextViewModel: PostSubmissionContextViewModel
    
    let onFlairSelected: (Flair) -> Void
    
    var body: some View {
        Group {
            if postSubmissionContextViewModel.flairs.isEmpty {
                ZStack {
                    if postSubmissionContextViewModel.isLoadingFlairs {
                        ProgressIndicator()
                    } else if let error = postSubmissionContextViewModel.flairsError {
                        Text("Unable to load flairs. Tap to retry. Error: \(error.localizedDescription)")
                            .primaryText()
                            .padding(16)
                            .onTapGesture {
                                postSubmissionContextViewModel.fetchFlairs()
                            }
                    } else {
                        Text("No flairs available")
                            .primaryText()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(postSubmissionContextViewModel.flairs, id: \.id) { flair in
                            TouchRipple(action: {
                                onFlairSelected(flair)
                                dismiss()
                            }) {
                                FlairRowView(flair: flair)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            postSubmissionContextViewModel.fetchFlairs()
        }
    }
}

