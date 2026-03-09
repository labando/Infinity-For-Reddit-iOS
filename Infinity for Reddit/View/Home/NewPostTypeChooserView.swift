//
//  NewPostTypeChooserView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-03.
//

import SwiftUI

struct NewPostTypeChooserView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        RootView {
            ScrollView {
                VStack(spacing: 0) {
                    SimpleTouchItemRow(text: "Text", icon: "text.page") {
                        navigationManager.append(AppNavigation.submitTextPost)
                    }
                    
                    SimpleTouchItemRow(text: "Link", icon: "link") {
                        navigationManager.append(AppNavigation.submitLinkPost)
                    }
                    
                    SimpleTouchItemRow(text: "Video", icon: "video") {
                        navigationManager.append(AppNavigation.submitVideoPost)
                    }
                    
                    SimpleTouchItemRow(text: "Image", icon: "photo") {
                        navigationManager.append(AppNavigation.submitImagePost)
                    }
                    
                    SimpleTouchItemRow(text: "Gallery", icon: "square.stack") {
                        navigationManager.append(AppNavigation.submitGalleryPost)
                    }
                    
                    SimpleTouchItemRow(text: "Poll", icon: "chart.bar.xaxis") {
                        navigationManager.append(AppNavigation.submitPollPost)
                    }
                }
            }
        }
        .limitedWidth()
    }
}
