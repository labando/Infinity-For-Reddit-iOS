//
//  OnboardingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2026-01-01.
//

import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var currentIndex = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Reddit, your way",
            subtitle: "Filters, themes, and browsing all in your hands.",
            image: "bolt.fill"
        ),
        OnboardingPage(
            title: "Post anything",
            subtitle: "Text, images, videos, GIFs, galleries, links, and polls exactly as you want.",
            image: "sparkles"
        ),
        OnboardingPage(
            title: "Browse without limits",
            subtitle: "Subscribe, save, vote, and revisit, even when logged out.",
            image: "eye.slash.fill"
        )
    ]
    
    var body: some View {
        RootView {
            GeometryReader { proxy in
                VStack {
                    TabView(selection: $currentIndex) {
                        ForEach(pages.indices, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .padding(16)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    PageIndicator(
                        count: pages.count,
                        currentIndex: currentIndex
                    )
                    
                    Button(action: advance) {
                        Text(currentIndex == pages.count - 1 ? "Get Started" : "Next")
                            .frame(maxWidth: 500)
                    }
                    .filledButton()
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, proxy.size.height > 1000 ? 120 : 16)
                }
            }
        }
        .animation(.default, value: currentIndex)
    }
    
    private func advance() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
        } else {
            onFinish()
        }
    }
    
    struct OnboardingPage: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let image: String
    }
    
    struct OnboardingPageView: View {
        @EnvironmentObject private var customThemeViewModel: CustomThemeViewModel
        
        let page: OnboardingPage

        var body: some View {
            VStack(spacing: 24) {
                SwiftUI.Image(systemName: page.image)
                    .font(.system(size: 64))

                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color(hex: customThemeViewModel.currentCustomTheme.primaryTextColor))
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundStyle(Color(hex: customThemeViewModel.currentCustomTheme.secondaryTextColor))
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
    
    struct PageIndicator: View {
        @EnvironmentObject private var customThemeViewModel: CustomThemeViewModel
        
        let count: Int
        let currentIndex: Int

        var body: some View {
            HStack(spacing: 8) {
                ForEach(0..<count, id: \.self) { index in
                    Capsule()
                        .fill(Color(hex: index == currentIndex ? customThemeViewModel.currentCustomTheme.primaryTextColor : customThemeViewModel.currentCustomTheme.secondaryTextColor))
                        .frame(width: index == currentIndex ? 18 : 6, height: 6)
                        .animation(.easeInOut, value: currentIndex)
                }
            }
            .padding(.bottom, 12)
        }
    }
}
