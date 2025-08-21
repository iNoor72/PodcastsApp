//
//  AppCoordinator.swift
//  Common
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Foundation
import SwiftUI
import Common

public final class AppCoordinator: RoutableCoordinator {
    public enum Route: Hashable {
        case homeScreen
        case searchScreen
    }
    
    public init(path: [Route], modal: ModalRoute<Route>? = nil) {
        self.path = path
        self.modal = modal
    }
    
    @Published
    public var path: [Route] = []
    
    @Published
    public var modal: ModalRoute<Route>?
    
    @ViewBuilder
    public func view(for route: Route) -> some View {
        switch route {
        case .homeScreen:
            AnyView(HomeScreenFactory.make(rootCoordinator: self))
        case .searchScreen:
            AnyView(SearchScreenFactory.make(rootCoordinator: self))
        }
    }
}
