//
// SubredditDetailsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-05-01

import SwiftUI
import MarkdownUI

struct SubredditDetailsView: View {
    @State var selectedTab = 0
    @State private var subscribeTask: Task<Void, Never>?
    
    @StateObject var subredditDetailsViewModel : SubredditDetailsViewModel
    
    init(subredditName: String) {
        _subredditDetailsViewModel = StateObject(
            wrappedValue: SubredditDetailsViewModel(
                subredditName: subredditName,
                subredditDetailsRepository: SubredditDetailsRepository()
            )
        )
    }
    
    var body: some View {
        // Top Section (User Info)
        VStack(spacing: 0) {
            if let subredditData = subredditDetailsViewModel.subredditData {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        CustomWebImage(
                            subredditData.iconUrl,
                            width: 80,
                            height: 80,
                            circleClipped: true
                        )
                        .padding(.vertical, 20)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("u/\(subredditData.name)")
                                .username()
                                .font(.title2)
                                .bold()
                            
                            Button(action: {
                                subscribeTask?.cancel()
                                subscribeTask = Task {
                                    await subredditDetailsViewModel.toggleSubscribeSubreddit()
                                }
                            }) {
                                Text(subredditDetailsViewModel.isSubscribed ? "Subscribed" : "Subscribe")
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Subscribers: \(subredditData.nSubscribers ?? 0)")
                            .primaryText()
                        
                        Spacer()
                        
                        Text("Since: \(subredditDetailsViewModel.formattedCakeDay(TimeInterval(subredditData.createdUTC ?? 0)))")
                            .primaryText()
                            .padding(.leading, 20)
                    }
                    .padding(.bottom, 10)
                    
                    subredditData.sidebarDescription.map {
                        Markdown($0)
                            .themedMarkdown()
                            .padding(0)
                    }
                    
//                    SegmentedPicker(selectedValue: $selectedTab, values: ["Posts", "About"])
//                        .padding(4)
                }
                .padding(.horizontal, 20)
                
            }
        }
        .task {
            if subredditDetailsViewModel.subredditData == nil {
                await subredditDetailsViewModel.fetchSubredditDetails()
            }
        }
        .themedNavigationBar()
    }
    
}

