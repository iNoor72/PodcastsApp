//
//  PodcastsApp.swift
//  Podcasts
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import DI
import Common
import DebugSwift

@main
struct PodcastApp: App {
    private let coordinator = AppCoordinator(path: [])
    private var debugSwift: DebugSwift
    
    init() {
        FontManager.registerFonts()
        
        #if DEBUG
        debugSwift = DebugSwift()
        debugSwift.setup()
        debugSwift.show()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView(
                coordinator: coordinator,
                root: {
                    coordinator.view(for: .homeScreen)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Home")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        coordinator.path.append(.searchScreen)
                                    }
                            }
                        }
                        .toolbarBackground(.black, for: .navigationBar)
                }
            )
            .accentColor(.white)
        }
    }
}
