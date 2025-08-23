//
//  HomeScreenFactory.swift
//  DI
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import Common
import Domain
import Data
import NetworkLayer

final class HomeScreenFactory: AnyFactory {
    @MainActor static func make(rootCoordinator: any NavigationCoordinator) -> some View {
        let networkService = NetworkManager.shared
        let repository = SectionsRepository(network: networkService)
        let useCase = DefaultFetchSectionsUseCase(sectionsRepository: repository)
        let coordinator = HomeCoordinator(rootCoordinator: rootCoordinator)
        let dependencies = HomeScreenViewModelDependencies(coordinator: coordinator, fetchPodcastsUseCase: useCase)
        
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        return HomeScreen(viewModel: viewModel)
    }
}
