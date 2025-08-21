//
//  SearchScreen.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import Common

public struct SearchScreen: View {
    private let coordinator: SearchCoordinator
    
    public init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
        
        public var body: some View {
            Text("A")
                .font(.title)
            Button("Navigate to B") {
                coordinator.routeToViewB()
            }
        }
}
