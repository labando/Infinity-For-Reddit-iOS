//
//  NavigationBarMenuManager.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-01.
//

import Foundation

public class NavigationBarMenuManager: ObservableObject {
    @Published private var stack: [[NavigationBarMenuItem]] = []
    
    var items: [NavigationBarMenuItem] {
        stack.flatMap { $0 }
    }
    
    func setRootItems(_ items: [NavigationBarMenuItem]) {
        stack = [items]
    }
    
    func push(_ items: [NavigationBarMenuItem]) {
        stack.append(items)
    }
    
    func pop() {
        if stack.count > 0 {
            stack.removeLast()
        }
    }
}
