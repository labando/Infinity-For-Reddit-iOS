//
//  CustomEnvironment.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-11-29.
//

import SwiftUI
import Swinject

struct DependencyManagerKey: EnvironmentKey {
    static let defaultValue: Container = DependencyManager.shared.container
}

extension EnvironmentValues {
    public var dependencyManager: Container {
        get { self[DependencyManagerKey.self] } set { self[DependencyManagerKey.self] = newValue }
    }
}
