//
//  SearchScreenFactory.swift
//  DI
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import Common

final class SearchScreenFactory: AnyFactory {
    typealias Screen = View
    
    @MainActor static func make(rootCoordinator: any RoutableCoordinator) -> any Screen {
        EmptyView()
    }
}
