//
//  PodcastsApp.swift
//  Podcasts
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import Common
import PresentationLayer
import DebugSwift

@main
struct PodcastApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    private let debugSwift = DebugSwift()
    
    init() {
        debugSwift.setup()
        debugSwift.setup(disable: [.leaksDetector])
        debugSwift.show()
    }
    
    var body: some Scene {
        WindowGroup {
            CustomNavigationView(appCoordinator: appCoordinator)
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
}

struct CustomNavigationView: View {
    @ObservedObject private var appCoordinator: AppCoordinator
    
    public init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    var body: some View {
        NavigationStack(path: $appCoordinator.paths) {
            appCoordinator.resolveInitialRouter().makeView()
                .navigationDestination(for: AnyRoutable.self) { coordinator in
                    coordinator.makeView()
                }
        }
    }
}
