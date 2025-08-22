//
// SubmitPollPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI
        
struct SubmitPollPostView: View {
    var body: some View {
        VStack {
            Text("SubmitPollPostView")
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Poll Post")
        .toolbar {
            NavigationBarMenu()
        }
    }
}

