//
// SubmitGalleryPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI
        
struct SubmitGalleryPostView: View {
    var body: some View {
        VStack {
            Text("SubmitGalleryPostView")
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Gallery Post")
        .toolbar {
            NavigationBarMenu()
        }
    }
}
