//
// SubmitImagePostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI
        
struct SubmitImagePostView: View {
    var body: some View {
        VStack {
            Text("SubmitImagePostView")
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Image Post")
        .toolbar {
            NavigationBarMenu()
        }
    }
}

