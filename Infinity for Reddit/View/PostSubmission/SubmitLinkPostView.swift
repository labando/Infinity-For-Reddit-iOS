//
// SubmitLinkPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI
import MarkdownUI

struct SubmitLinkPostView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var themeViewModel: CustomThemeViewModel
    
    @StateObject private var postSubmissionContextViewModel: PostSubmissionContextViewModel
    @StateObject private var submitLinkPostViewModel: SubmitLinkPostViewModel
    
    @FocusState private var markdownToolbarFocusedField: MarkdownFieldType?
    @FocusState private var focusedField: FieldType?
    
    @State private var titleTextViewCanFocus: Bool = true
    @State private var contentTextViewCanFocus: Bool = true
    @State private var markdownToolbarHeight: CGFloat = 0
    @State private var showSelectSubredditView: Bool = false
    @State private var showFlairSheet: Bool = false
    @State private var titleSelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var bodySelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var showMarkdownPreview: Bool = false
    
    init() {
        _postSubmissionContextViewModel = StateObject(
            wrappedValue: PostSubmissionContextViewModel(ruleRepository: RuleRepository(), flairRepository: FlairRepository())
        )
        _submitLinkPostViewModel = StateObject(
            wrappedValue: SubmitLinkPostViewModel()
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            UserPicker {
                                submitLinkPostViewModel.selectedAccount = $0
                            }
                            
                            PostSubmissionSubredditChooserView(text: "Choose a subreddit", iconUrl: nil, action: {
                                navigationManager.path.append(SelectSubredditNavigation.selectSubreddit)
                            })
                            .environmentObject(navigationManager)
                            
                            Divider()
                            
                            HStack(spacing: 16) {
                                if postSubmissionContextViewModel.selectedSubreddit != nil {
                                    FlairFilledButton(selectedFlair: submitLinkPostViewModel.selectedFlair) {
                                        if submitLinkPostViewModel.selectedFlair != nil {
                                            submitLinkPostViewModel.selectedFlair = nil
                                        } else {
                                            Task {
                                                await postSubmissionContextViewModel.fetchFlairs()
                                                showFlairSheet = true
                                            }
                                        }
                                    }
                                }
                                
                                SpoilerFilledButton(isSpoiler: $submitLinkPostViewModel.isSpoiler)
                                
                                SensitiveFilledButton(isSensitive: $submitLinkPostViewModel.isSensitive)
                        
                                Spacer()
                            }
                            .padding(16)
                            
                            TouchRipple(action: {
                                submitLinkPostViewModel.receiveReplyNotification.toggle()
                            }) {
                                HStack {
                                    RowText("Receive post reply notifications")
                                        .secondaryText()
                                    
                                    Toggle(isOn: $submitLinkPostViewModel.receiveReplyNotification) {}
                                        .labelsHidden()
                                        .themedToggle()
                                        .excludeFromTouchRipple()
                                }
                                .padding(16)
                            }
                            
                            
                            Divider()
                            
                            HStack {
                                CustomTextField(
                                    "Title",
                                    text: $submitLinkPostViewModel.title,
                                    singleLine: true,
                                    keyboardType: .default,
                                    showBorder: false,
                                    fieldType: .title,
                                    focusedField: $focusedField
                                )
                                
                                Button("Suggest Title") {
                                    Task {
                                        await submitLinkPostViewModel.suggestTitle()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color(hex: themeViewModel.currentCustomTheme.colorPrimary))
                                .controlSize(.regular)
                                .contentShape(Rectangle())
                            }
                            .padding(16)
                            
                            CustomTextField(
                                "URL",
                                text: $submitLinkPostViewModel.url,
                                singleLine: true,
                                keyboardType: .URL,
                                showBorder: false,
                                fieldType: .url,
                                focusedField: $focusedField
                            )
                            .padding(16)
                            
                            ZStack(alignment: .topLeading) {
                                MarkdownTextField(text: $submitLinkPostViewModel.content, selectedRange: $bodySelectedRange, canFocus: $contentTextViewCanFocus)
                                    .frame(minHeight: 300)
                                    .contentShape(Rectangle())
                                
                                if submitLinkPostViewModel.content.isEmpty {
                                    Text("Content")
                                        .secondaryText()
                                }
                            }
                            .padding(16)
                        }
                    }
                    
                    Spacer().frame(height: markdownToolbarHeight)
                    
                }
                
                MarkdownToolbar(
                    text: $submitLinkPostViewModel.content,
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
        .addTitleToInlineNavigationBar("Link Post")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showMarkdownPreview = true
                } label: {
                    SwiftUI.Image(systemName: "eye")
                }
                
                Button {
                    print("Submit Link Post")
                } label: {
                    SwiftUI.Image(systemName: "paperplane.fill")
                }
            }
        }
        .sheet(isPresented: $showFlairSheet) {
            FlairChooserSheet(postSubmissionContextViewModel: postSubmissionContextViewModel) { flair in
                submitLinkPostViewModel.selectedFlair = flair
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showMarkdownPreview) {
            MarkdownViewerSheet(markdown: submitLinkPostViewModel.content)
        }
    }
    
    private enum FieldType: Hashable {
        case title, url
    }
}
