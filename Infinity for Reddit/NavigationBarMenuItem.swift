//
//  NavigationBarMenuItem.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-01.
//

import Foundation

struct NavigationBarMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
}
