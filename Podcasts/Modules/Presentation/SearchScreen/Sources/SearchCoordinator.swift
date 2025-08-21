//
//  SearchCoordinator.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Foundation
import Common
import SwiftUI

public final class SearchCoordinator: RoutableCoordinator {
    public enum Route: Hashable {
        case viewB
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
        case .viewB:
            ProgressView()
        }
    }
}

public extension SearchCoordinator {
    func routeToViewB() {
        
    }
}
