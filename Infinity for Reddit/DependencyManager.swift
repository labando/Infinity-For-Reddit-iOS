//
//  DependencyManager.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-11-29.
//
import Swinject

class DependencyManager {
    static let shared = DependencyManager()
    let container: Container
    
    private init() {
        container = Container()
        
        registerDependencies()
    }
    
    private func registerDependencies() {
        
    }
}
