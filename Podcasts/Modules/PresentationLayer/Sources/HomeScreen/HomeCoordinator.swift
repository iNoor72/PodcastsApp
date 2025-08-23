//
//  HomeCoordinator.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import Foundation
import Common
import SwiftUI

public final class HomeCoordinator: Routable {
    public let id: UUID = UUID()
    private let rootCoordinator: NavigationCoordinator

    public enum Route: Equatable {
        case home
        case search
    }
    
    public init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    @MainActor public func makeView() -> AnyView {
        AnyView(
            HomeScreenFactory.make(rootCoordinator: rootCoordinator)
        )
    }
    
    public static func == (lhs: HomeCoordinator, rhs: HomeCoordinator) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public func routeToSearch() {
        let searchCoordinator = SearchCoordinator(rootCoordinator: rootCoordinator)
        rootCoordinator.push(searchCoordinator)
    }

}
