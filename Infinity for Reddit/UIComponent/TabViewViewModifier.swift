//
//  TabViewViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-23.
//

import SwiftUI

struct TabViewCustomThemeViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            .tint(Color(hex: themeViewModel.currentCustomTheme.colorPrimary))
    }
}

struct TabViewGroupViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            .background(TabBarAccessor { tabBar in
                tabBar.barTintColor = UIColor(Color(hex: themeViewModel.currentCustomTheme.bottomAppBarBackgroundColor))
                tabBar.backgroundColor = UIColor(Color(hex: themeViewModel.currentCustomTheme.bottomAppBarBackgroundColor))
                tabBar.layer.borderColor = UIColor(Color(hex: themeViewModel.currentCustomTheme.bottomAppBarBackgroundColor)).cgColor
                tabBar.unselectedItemTintColor = UIColor(Color(hex: themeViewModel.currentCustomTheme.bottomAppBarIconColor))
            })
    }
}

struct TabBarAccessor: UIViewControllerRepresentable {
    var callback: (UITabBar) -> Void
    private let proxyController = ViewController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) ->
                              UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
    }
    
    typealias UIViewControllerType = UIViewController

    private class ViewController: UIViewController {
        var callback: (UITabBar) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = self.tabBarController {
                self.callback(tabBar.tabBar)
            }
        }
    }
}
