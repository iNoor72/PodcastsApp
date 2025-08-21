//
//  PodcastsApp.swift
//  Podcasts
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import DI
import Common

@main
struct PodcastApp: App {
    private let coordinator = AppCoordinator(path: [])
    
    var body: some Scene {
        WindowGroup {
            NavigationView(
                coordinator: coordinator,
                root: {
                    coordinator.view(for: .homeScreen)
                }
            )
        }
    }
}
