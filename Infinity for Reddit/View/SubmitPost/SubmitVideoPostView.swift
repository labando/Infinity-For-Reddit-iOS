//
// SubmitVideoPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI
        
struct SubmitVideoPostView: View {
    var body: some View {
        VStack {
            Text("SubmitVideoPostView")
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Video Post")
        .toolbar {
            NavigationBarMenu()
        }
    }
}

