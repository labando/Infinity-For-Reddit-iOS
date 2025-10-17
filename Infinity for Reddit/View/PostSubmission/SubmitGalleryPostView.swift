//
// SubmitGalleryPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21

import SwiftUI
import MarkdownUI
import MijickCamera
import PhotosUI

struct SubmitGalleryPostView: View {
    @StateObject private var postSubmissionContextViewModel: PostSubmissionContextViewModel
    @StateObject private var submitGalleryPostViewModel: SubmitGalleryPostViewModel
    
    @FocusState private var markdownToolbarFocusedField: MarkdownFieldType?
    @FocusState private var focusedField: FieldType?
    
    @State private var contentTextViewCanFocus: Bool = true
    @State private var markdownToolbarHeight: CGFloat = 0
    @State private var titleSelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var bodySelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var showMarkdownPreview: Bool = false
    @State private var showGallerySheet: Bool = false
    @State private var showPhotoPicker: Bool = false
    @State private var showCamera: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    init() {
        _postSubmissionContextViewModel = StateObject(
            wrappedValue: PostSubmissionContextViewModel(ruleRepository: RuleRepository(), flairRepository: FlairRepository())
        )
        _submitGalleryPostViewModel = StateObject(wrappedValue: SubmitGalleryPostViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            UserPicker {
                                submitGalleryPostViewModel.selectedAccount = $0
                            }
                            
                            PostSubmissionSubredditChooserView(postSubmissionContextViewModel: postSubmissionContextViewModel) { subscribedSubredditData in
                                postSubmissionContextViewModel.selectedSubreddit = subscribedSubredditData
                            }
                            
                            Divider()
                            
                            PostSubmissionContextView(postSubmissionContextViewModel: postSubmissionContextViewModel)
                            
                            Divider()
                            
                            CustomTextField(
                                "Title",
                                text: $submitGalleryPostViewModel.title,
                                singleLine: true,
                                keyboardType: .default,
                                showBorder: false,
                                fieldType: .title,
                                focusedField: $focusedField
                            )
                            .padding(16)
                            
                            ZStack(alignment: .topLeading) {
                                MarkdownTextField(text: $submitGalleryPostViewModel.content, selectedRange: $bodySelectedRange, canFocus: $contentTextViewCanFocus)
                                    .contentShape(Rectangle())
                                
                                if submitGalleryPostViewModel.content.isEmpty {
                                    Text("Content")
                                        .secondaryText()
                                }
                            }
                            .padding(16)
                            
                            if !submitGalleryPostViewModel.capturedImages.isEmpty {
                                VStack(spacing: 16) {
                                    ForEach(submitGalleryPostViewModel.capturedImages.indices, id: \.self) { index in
                                        SwiftUI.Image(uiImage: submitGalleryPostViewModel.capturedImages[index])
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(8)
                                            .padding(.horizontal, 16)
                                    }
                                    
                                    if submitGalleryPostViewModel.capturedImages.count < 20 {
                                        GallerySelectionToolbar(
                                            onTapGallery: { showGallerySheet = true }
                                        )
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                            } else {
                                GallerySelectionToolbar{
                                    showGallerySheet = true
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: markdownToolbarHeight)
                    
                }
                
                MarkdownToolbar(
                    text: $submitGalleryPostViewModel.content,
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
        .addTitleToInlineNavigationBar("Gallery Post")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showMarkdownPreview = true
                } label: {
                    SwiftUI.Image(systemName: "eye")
                }
                
                Button {
                    print("Submit Gallery Post")
                } label: {
                    SwiftUI.Image(systemName: "paperplane.fill")
                }
            }
        }
        .sheet(isPresented: $showMarkdownPreview) {
            MarkdownViewerSheet(markdown: submitGalleryPostViewModel.content)
        }
        .sheet(isPresented: $showGallerySheet) {
            GallerySelectionSheet(
                onCameraTap: {
                    showCamera = true
                    showGallerySheet = false
                },
                onPhotoPickerTap: {
                    showPhotoPicker = true
                    showGallerySheet = false
                }
            )
            .presentationDragIndicator(.visible)
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        .onChange(of: selectedPhotoItem) { _, newSelectedItem in
            Task {
                if let selectedItem = newSelectedItem,
                   let imageData = try? await selectedItem.loadTransferable(type: Data.self),
                   let pickedImage = UIImage(data: imageData) {
                    submitGalleryPostViewModel.addImage(pickedImage)
                } else {
                    // Error handling
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            if Utils.checkCameraAvailability() {
                MCamera()
                    .onImageCaptured { capturedImage, controller in
                        submitGalleryPostViewModel.addImage(capturedImage)
                        controller.closeMCamera()
                    }
                    .setCloseMCameraAction {
                        showCamera = false
                    }
                    .setCameraOutputType(.photo)
                    .setAudioAvailability(false)
                    .setCameraScreen { cameraManager, id, closeMCameraAction in
                        DefaultCameraScreen(
                            cameraManager: cameraManager,
                            namespace: id,
                            closeMCameraAction: closeMCameraAction
                        ).cameraOutputSwitchAllowed(false)
                    }
                    .startSession()
            } else {
                VStack {
                    Text("Camera not available")
                        .padding(.bottom, 60)
                    
                    Button("Close") {
                        showCamera = false
                    }
                    .filledButton()
                }
            }
        }
    }
    
    private enum FieldType: Hashable {
        case title
    }
}

private struct GallerySelectionToolbar: View {
    @EnvironmentObject private var customThemeViewModel: CustomThemeViewModel
    
    let onTapGallery: () -> Void
    let buttonSize: CGFloat = 24
    
    var body: some View {
        HStack(spacing: 32) {
            Button {
                onTapGallery()
            } label: {
                SwiftUI.Image(systemName: "photo.fill.on.rectangle.fill")
                    .font(.system(size: buttonSize))
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Circle().fill(Color(hex: customThemeViewModel.currentCustomTheme.colorAccent)))
            }
        }
        .padding(16)
    }
}
