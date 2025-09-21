//
// SubmitTextPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21

import SwiftUI
import MarkdownUI

struct SubmitTextPostView: View {
    @EnvironmentObject private var themeViewModel: CustomThemeViewModel
    
    @StateObject private var postSubmissionContextViewModel: PostSubmissionContextViewModel
    @StateObject private var submitTextPostViewModel: SubmitTextPostViewModel
    
    @FocusState private var markdownToolbarFocusedField: MarkdownFieldType?
    @FocusState private var focusedField: FieldType?
    
    @State private var titleTextViewCanFocus: Bool = true
    @State private var contentTextViewCanFocus: Bool = true
    @State private var markdownToolbarHeight: CGFloat = 0
    @State private var receiveReplyNotification: Bool = false
    @State private var showSelectSubredditView: Bool = false
    @State private var showFlairSheet: Bool = false
    @State private var isSpoiler: Bool = false
    @State private var isSensitive: Bool = false
    @State private var titleSelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var bodySelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var showMarkdownPreview: Bool = false
    
    init() {
        _postSubmissionContextViewModel = StateObject(
            wrappedValue: PostSubmissionContextViewModel(ruleRepository: RuleRepository(), flairRepository: FlairRepository())
        )
        _submitTextPostViewModel = StateObject(
            wrappedValue: SubmitTextPostViewModel()
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            UserPicker {
                                submitTextPostViewModel.selectedAccount = $0
                            }
                            
                            PostSubmissionSubredditChooserView(postSubmissionContextViewModel: postSubmissionContextViewModel) { subscribedSubredditData in
                                postSubmissionContextViewModel.selectedSubreddit = subscribedSubredditData
                            }
                            
                            Divider()
                            
                            HStack(spacing: 16) {
                                if postSubmissionContextViewModel.selectedSubreddit != nil {
                                    FlairFilledButton(selectedFlair: submitTextPostViewModel.selectedFlair) {
                                        if submitTextPostViewModel.selectedFlair != nil {
                                            submitTextPostViewModel.selectedFlair = nil
                                        } else {
                                            Task {
                                                await postSubmissionContextViewModel.fetchFlairs()
                                                showFlairSheet = true
                                            }
                                        }
                                    }
                                }
                                
                                SpoilerFilledButton(isSpoiler: $isSpoiler)
                                
                                SensitiveFilledButton(isSensitive: $isSensitive)
                        
                                Spacer()
                            }
                            .padding(16)
                            
                            TouchRipple(action: {
                                receiveReplyNotification.toggle()
                            }) {
                                HStack {
                                    RowText("Receive post reply notifications")
                                        .secondaryText()
                                    
                                    Toggle(isOn: $receiveReplyNotification) {}
                                        .labelsHidden()
                                        .themedToggle()
                                        .excludeFromTouchRipple()
                                }
                                .padding(16)
                            }
                            
                            Divider()
                            
                            CustomTextField(
                                "Title",
                                text: $submitTextPostViewModel.title,
                                singleLine: true,
                                keyboardType: .default,
                                showBorder: false,
                                fieldType: .title,
                                focusedField: $focusedField
                            )
                            .padding(16)
                            
                            ZStack(alignment: .topLeading) {
                                MarkdownTextField(text: $submitTextPostViewModel.content, selectedRange: $bodySelectedRange, canFocus: $contentTextViewCanFocus)
                                    .frame(minHeight: 300)
                                    .contentShape(Rectangle())
                                
                                if submitTextPostViewModel.content.isEmpty {
                                    Text("Content")
                                        .secondaryText()
                                }
                            }
                            .padding(16)
                        }
                    }
                    
                    Spacer()
                        .frame(height: markdownToolbarHeight)                    
                }
                
                MarkdownToolbar(
                    text: $submitTextPostViewModel.content,
                    selectedRange: $bodySelectedRange,
                    toolbarHeight: $markdownToolbarHeight,
                    focusedField: $markdownToolbarFocusedField
                )
            }
            
            KeyboardToolbar {
                contentTextViewCanFocus = false
                markdownToolbarFocusedField = nil
                focusedField = nil
            }
        }
        .frame(maxHeight: .infinity)
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Text Post")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showMarkdownPreview = true
                } label: {
                    SwiftUI.Image(systemName: "eye")
                }
                
                Button {
                    print("Submit Text Post")
                } label: {
                    SwiftUI.Image(systemName: "paperplane.fill")
                }
            }
        }
        .sheet(isPresented: $showFlairSheet) {
            FlairChooserSheet(postSubmissionContextViewModel: postSubmissionContextViewModel) { flair in
                submitTextPostViewModel.selectedFlair = flair
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showMarkdownPreview) {
            MarkdownViewerSheet(markdown: submitTextPostViewModel.content)
        }
    }
    
    private enum FieldType: Hashable {
        case title
    }
}
