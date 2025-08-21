//
//  AnyFactory.swift
//  DI
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Common

public protocol AnyFactory {
    associatedtype Screen
    @MainActor static func make(rootCoordinator: any RoutableCoordinator) -> Screen
}
