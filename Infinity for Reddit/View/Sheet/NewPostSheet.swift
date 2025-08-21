//
// NewPostSheet.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-06-28

import SwiftUI

struct NewPostSheet: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SimpleTouchItemRow(text: "Text", icon: "text.page") {
                    dismiss()
                    navigationManager.path.append(AppNavigation.submitTextPost)
                }
                
                SimpleTouchItemRow(text: "Link", icon: "link") {
                    dismiss()
                    navigationManager.path.append(AppNavigation.submitLinkPost)
                }
                
                SimpleTouchItemRow(text: "Video", icon: "video") {
                    dismiss()
                    navigationManager.path.append(AppNavigation.submitVideoPost)
                }
                
                SimpleTouchItemRow(text: "Image", icon: "photo") {
                    dismiss()
                    navigationManager.path.append(AppNavigation.submitImagePost)
                }
                
                SimpleTouchItemRow(text: "Gallery", icon: "square.stack") {
                    dismiss()
                    navigationManager.path.append(AppNavigation.submitGalleryPost)
                }
                
                SimpleTouchItemRow(text: "Poll", icon: "chart.bar.xaxis") {
                    dismiss()
                    navigationManager.path.append(AppNavigation.submitPollPost)
                }
            }
            .padding(.top, 30)
        }
    }
}
