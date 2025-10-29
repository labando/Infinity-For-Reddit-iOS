//
// SubmitTextPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21

import SwiftUI
import MarkdownUI
import PhotosUI

struct SubmitTextPostView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var snackbarManager: SnackbarManager
    
    @StateObject private var postSubmissionContextViewModel: PostSubmissionContextViewModel
    @StateObject private var submitTextPostViewModel: SubmitTextPostViewModel
    
    @FocusState private var markdownToolbarFocusedField: MarkdownFieldType?
    @FocusState private var focusedField: FieldType?

    @State private var contentTextViewCanFocus: Bool = true
    @State private var markdownToolbarHeight: CGFloat = 0
    @State private var titleSelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var bodySelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var showMarkdownPreview: Bool = false
    @State private var cursorPosition: CGPoint = .zero
    @State private var showEmbeddedImagesSheet: Bool = false
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    init() {
        _postSubmissionContextViewModel = StateObject(
            wrappedValue: PostSubmissionContextViewModel(ruleRepository: RuleRepository(), flairRepository: FlairRepository())
        )
        _submitTextPostViewModel = StateObject(
            wrappedValue: SubmitTextPostViewModel(
                submitPostRepository: SubmitPostRepository(),
                mediaUploadRepository: MediaUploadRepository()
            )
        )
    }
    
    var body: some View {
        RootView {
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
                                
                                PostSubmissionContextView(postSubmissionContextViewModel: postSubmissionContextViewModel)
                                
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
                                .padding(.horizontal, 16)
                                .padding(.top, 16)

                                MarkdownTextField(hint: "Content", text: $submitTextPostViewModel.content, selectedRange: $bodySelectedRange, canFocus: $contentTextViewCanFocus)
                                    .contentShape(Rectangle())
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
                        focusedField: $markdownToolbarFocusedField,
                        enableImageUpload: true,
                        onImageUpload: {
                            showEmbeddedImagesSheet = true
                        }
                    )
                }
                
                KeyboardToolbar {
                    contentTextViewCanFocus = false
                    markdownToolbarFocusedField = nil
                    focusedField = nil
                }
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
                    submitTextPostViewModel.submitPost(
                        subreddit: postSubmissionContextViewModel.selectedSubreddit,
                        flair: postSubmissionContextViewModel.selectedFlair,
                        isSpoiler: postSubmissionContextViewModel.isSpoiler,
                        isSensitive: postSubmissionContextViewModel.isSensitive,
                        receivePostReplyNotifications: postSubmissionContextViewModel.receivePostReplyNotification
                    )
                } label: {
                    SwiftUI.Image(systemName: "paperplane.fill")
                }
            }
        }
        .sheet(isPresented: $showMarkdownPreview) {
            MarkdownViewerSheet(markdown: submitTextPostViewModel.content)
        }
        .sheet(isPresented: $showEmbeddedImagesSheet) {
            MarkdownEmbeddedImagesSheet(embeddedImages: $submitTextPostViewModel.embeddedImages, onAddImage: {
                showEmbeddedImagesSheet = false
                showPhotoPicker = true
            }, onInsertImage: { uploadedImage, caption in
                showEmbeddedImagesSheet = false
                
                guard let range = Range(bodySelectedRange, in: submitTextPostViewModel.content) else {
                    return
                }
                
                let beforeRange = submitTextPostViewModel.content[..<range.lowerBound]
                let afterRange = submitTextPostViewModel.content[range.upperBound...]

                let leftCount = min(2, beforeRange.count)
                let leftStart = beforeRange.index(beforeRange.endIndex, offsetBy: -leftCount)
                let leftSlice = beforeRange[leftStart..<beforeRange.endIndex]

                let leftNewlines: Int
                if leftSlice.allSatisfy({ $0 == "\n" || $0.isWhitespace }) {
                    leftNewlines = leftSlice.isEmpty ? 2 : leftSlice.filter { $0 == "\n" }.count
                } else if leftSlice.hasSuffix("\n") {
                    leftNewlines = 1
                } else {
                    leftNewlines = 0
                }

                let rightCount = min(2, afterRange.count)
                let rightEnd = afterRange.index(afterRange.startIndex, offsetBy: rightCount)
                let rightSlice = afterRange[afterRange.startIndex..<rightEnd]

                let rightNewlines: Int
                if rightSlice.allSatisfy({ $0 == "\n" || $0.isWhitespace }) {
                    rightNewlines = rightSlice.isEmpty ? 2 : rightSlice.filter { $0 == "\n" }.count
                } else if rightSlice.hasPrefix("\n") {
                    rightNewlines = 1
                } else {
                    rightNewlines = 0
                }
                
                let imageSyntax = "\(String(repeating: "\n", count: max(0, 2 - leftNewlines)))![\(caption)](\(uploadedImage.imageId ?? ""))\(String(repeating: "\n", count: max(0, 2 - rightNewlines)))"
                
                let newText: String
                if bodySelectedRange.length > 0 {
                    newText = submitTextPostViewModel.content.replacingCharacters(in: range, with: imageSyntax)
                    bodySelectedRange = NSRange(location: bodySelectedRange.location,
                                            length: imageSyntax.count)
                } else {
                    newText = submitTextPostViewModel.content.inserting(imageSyntax, at: bodySelectedRange.location)
                    bodySelectedRange = NSRange(location: bodySelectedRange.location + imageSyntax.count,
                                            length: 0)
                }
                submitTextPostViewModel.content = newText
            })
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPhotoItem) { _, newSelectedItem in
            Task {
                if let selectedItem = newSelectedItem,
                   let imageData = try? await selectedItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: imageData) {
                    print(Utils.isGIF(imageData: imageData))
                    submitTextPostViewModel.addEmbeddedImage(image)
                } else {
                    // Error handling
                }
            }
        }
        .onChange(of: submitTextPostViewModel.submitPostTask) { _, newValue in
            if newValue != nil {
                snackbarManager.showSnackbar(
                    text: "Submitting. Please wait...",
                    autoDismiss: false,
                    canDismissByGesture: false
                )
            }
        }
        .onChange(of: submitTextPostViewModel.submittedPostId) { _, newValue in
            if let id = newValue {
                snackbarManager.dismiss()
                navigationManager.replaceCurrentScreen(AppNavigation.postDetailsWithId(postId: id))
            }
        }
        .onReceive(submitTextPostViewModel.$error) { newValue in
            if let error = newValue {
                snackbarManager.showSnackbar(text: error.localizedDescription)
            }
        }
    }
    
    private enum FieldType: Hashable {
        case title
    }
}
