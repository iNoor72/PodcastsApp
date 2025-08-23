//
//  File.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import Foundation
import Common
import SwiftUI

public protocol HomeCoordinatorProtocol: AnyObject {
    func routeToSearchScreen()
}

public final class HomeCoordinator: RoutableCoordinator {
    public enum Route: Hashable {
        case search
    }
    
    public init(path: [Route], modal: ModalRoute<Route>? = nil) {
        self.path = path
        self.modal = modal
    }
    
    @Published
    public var path: [Route] = []
    
    @Published
    public var modal: ModalRoute<Route>?
    
    public weak var rootCoordinator: RoutableCoordinator?
    
    @ViewBuilder
    public func view(for route: Route) -> some View {
        switch route {
        case .search:
            ProgressView()
        }
    }
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    public func routeToSearchScreen() {
        path.append(.search)
    }
}
