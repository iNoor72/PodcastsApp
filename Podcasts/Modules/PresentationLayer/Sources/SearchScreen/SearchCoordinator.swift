//
//  SearchCoordinator.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Foundation
import Common
import SwiftUI

public final class SearchCoordinator: Routable {
    public let id: UUID = UUID()
    private let rootCoordinator: NavigationCoordinator
    
    public init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    @MainActor public func makeView() -> AnyView {
        AnyView(
            SearchScreenFactory.make(rootCoordinator: rootCoordinator)
        )
    }
    
    public static func == (lhs: SearchCoordinator, rhs: SearchCoordinator) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
