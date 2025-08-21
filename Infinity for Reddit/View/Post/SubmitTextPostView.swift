//
// SubmitTextPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21

import SwiftUI
        
struct SubmitTextPostView: View {
    var body: some View {
        VStack {
            Text("SubmitTextPostView")
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Text Post")
        .toolbar {
            NavigationBarMenu()
        }
    }
}
