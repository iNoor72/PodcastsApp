//
//  RoutableCoordinator.swift
//  Common
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import SwiftUI

@MainActor
public protocol RoutableCoordinator: AnyObject, ObservableObject {
    associatedtype Route: Hashable
    associatedtype Content: View

    var path: [Route] { get set }
    var modal: ModalRoute<Route>? { get set }

    @ViewBuilder
    func view(for route: Route) -> Content
}
