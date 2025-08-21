//
//  NavigationView.swift
//  Common
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import SwiftUI

public struct NavigationView<
    Coordinator: RoutableCoordinator,
    Root: View
>: View {
    @StateObject
    private var coordinator: Coordinator
    
    @ViewBuilder
    private let root: () -> Root

    public init(
        coordinator: Coordinator,
        root: @escaping () -> Root
    ) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self.root = root
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            root()
                // Horizontal navigation
                .navigationDestination(for: Coordinator.Route.self) { route in
                    coordinator.view(for: route)
                }
                // Fullscreen modal presentation
                .fullScreenCover(
                    item: Binding(
                        get: { coordinator.modal?.asFullScreen() },
                        set: { coordinator.modal = $0 }
                    ),
                    content: { modal in coordinator.view(for: modal.route) }
                )
                // Sheet modal presentation
                .sheet(
                    item: Binding(
                        get: { coordinator.modal?.asSheet() },
                        set: { coordinator.modal = $0 }
                    ),
                    content: { modal in coordinator.view(for: modal.route) }
                )
        }
    }
}
