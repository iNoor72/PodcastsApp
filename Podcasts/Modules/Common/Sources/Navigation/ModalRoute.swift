//
//  ModalRoute.swift
//  Common
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import Foundation

@frozen public enum ModalRoute<Route: Hashable>: Hashable, Identifiable {
    public var id: Int { hashValue }

    case fullScreen(Route)
    case sheet(Route)

    public var route: Route {
        switch self {
            case let .fullScreen(route): route
            case let .sheet(route): route
        }
    }

    public func asFullScreen() -> Self? {
        switch self {
            case .fullScreen: self
            case .sheet: nil
        }
    }

    public func asSheet() -> Self? {
        switch self {
            case .sheet: self
            case .fullScreen: nil
        }
    }
}
