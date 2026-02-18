//
//  DependencyManager.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-11-29.
//

import Swinject
import Alamofire
import GRDB
import Foundation

struct DependencyManager {
    static let shared = DependencyManager()
    
    let container: Container
    
    private init() {
        container = Container()
        registerDependencies(container)
    }
    
    private func registerDependencies(_ c: Container) {
        // TODO register dependencies on container
        c.register(Session.self) { _ in
            ProxyUtils.makeSession(interceptor: RedditAccessTokenInterceptor())
        }.inObjectScope(.container) // Singleton
        
        c.register(Session.self, name: "plain") { _ in
            ProxyUtils.makeSession()
        }.inObjectScope(.container)
        
        c.register(Session.self, name: "redgifs") { _ in
            ProxyUtils.makeSession(interceptor: RedgifsAccessTokenInterceptor())
        }.inObjectScope(.container)
        
        c.register(Session.self, name: "streamable") { _ in
            ProxyUtils.makeSession()
        }.inObjectScope(.container)
        
        c.register(Session.self, name: "vReddIt") { _ in
            ProxyUtils.makeSession()
        }.inObjectScope(.container)
        
        c.register(Session.self, name: "imgur") { _ in
            ProxyUtils.makeSession()
        }.inObjectScope(.container)
        
        c.register(DatabasePool.self) { _ in
            do {
                return try RedditGRDBDatabase.create()
            } catch {
                fatalError("Failed to create DatabasePool: \(error)")
            }
        }.inObjectScope(.container) // Singleton
    }
}
