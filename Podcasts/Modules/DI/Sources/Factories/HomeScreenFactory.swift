//
//  HomeScreenFactory.swift
//  DI
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import HomeScreen
import Common
import Domain
import Data
import NetworkLayer

final class HomeScreenFactory: AnyFactory {
    typealias Screen = View
    
    @MainActor static func make(rootCoordinator: any RoutableCoordinator) -> any Screen {
        let networkService = NetworkManager.shared
        let repository = SectionsRepository(network: networkService)
        let useCase = DefaultFetchSectionsUseCase(sectionsRepository: repository)
        let coordinator = HomeCoordinator(path: [])
        let dependencies = HomeScreenViewModelDependencies(coordinator: coordinator, fetchPodcastsUseCase: useCase)
        
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        coordinator.rootCoordinator = rootCoordinator
        return HomeScreen(viewModel: viewModel)
    }
}
