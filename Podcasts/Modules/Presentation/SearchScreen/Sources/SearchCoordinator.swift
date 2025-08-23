//
//  SearchCoordinator.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Foundation
import Common
import SwiftUI

public protocol SearchCoordinatorProtocol: AnyObject {
    
}

public final class SearchCoordinator: RoutableCoordinator, SearchCoordinatorProtocol {
    public enum Route: Hashable {
        //Add cases here when needed
    }
    
    public init(path: [Route], modal: ModalRoute<Route>? = nil) {
        self.path = path
        self.modal = modal
    }
    
    @Published
    public var path: [Route] = []
    
    @Published
    public var modal: ModalRoute<Route>?
    
    public weak var rootCoordinator: (any RoutableCoordinator)?
    
    @ViewBuilder
    public func view(for route: Route) -> some View {
        switch route {
        default:
            ProgressView()
        }
    }
}
