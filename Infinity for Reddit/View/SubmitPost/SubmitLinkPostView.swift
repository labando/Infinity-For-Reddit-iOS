//
// SubmitLinkPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI
        
struct SubmitLinkPostView: View {
    var body: some View {
        VStack {
            Text("SubmitLinkPostView")
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Link Post")
        .toolbar {
            NavigationBarMenu()
        }
    }
}

