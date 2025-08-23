//
//  AppCoordinator.swift
//  PresentationLayer
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation
import SwiftUI
import Common

public final class AppCoordinator: ObservableObject {
    @Published public var paths: NavigationPath
    
    public init(paths: NavigationPath = NavigationPath()) {
        self.paths = paths
    }
    
    public func resolveInitialRouter() -> any Routable {
        HomeCoordinator(rootCoordinator: self)
    }
}

extension AppCoordinator: NavigationCoordinator {
    public func push(_ router: any Routable) {
        DispatchQueue.main.async {
            let wrappedRouter = AnyRoutable(router)
            self.paths.append(wrappedRouter)
        }
    }
    
    public func popLast() {
        DispatchQueue.main.async {
            self.paths.removeLast()
        }
    }
    
    public func popToRoot() {
        DispatchQueue.main.async {
            self.paths.removeLast(self.paths.count)
        }
    }
}
