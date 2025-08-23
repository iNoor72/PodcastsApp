//
//  SearchScreenFactory.swift
//  DI
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import Common
import Domain
import Data
import NetworkLayer

final class SearchScreenFactory: AnyFactory {
    @MainActor static func make(rootCoordinator: any NavigationCoordinator) -> some View {
        let networkService = NetworkManager.shared
        let repository = SearchRepository(network: networkService)
        let useCase = DefaultSearchUseCase(repository: repository)
        let coordinator = SearchCoordinator(rootCoordinator: rootCoordinator)
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        return SearchScreen(viewModel: viewModel)
    }
}
