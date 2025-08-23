//
//  SearchScreenViewModel.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Foundation
import Domain

public struct SearchScreenViewModelDependencies {
    let coordinator: SearchCoordinator
    let searchUseCase: SearchUseCase
    
    public init(coordinator: SearchCoordinator, searchUseCase: SearchUseCase) {
        self.coordinator = coordinator
        self.searchUseCase = searchUseCase
    }
}

@frozen public enum SearchScreenViewState: Hashable {
    case initial
    case loading
    case loaded
    case error(String)
}

@MainActor
public final class SearchScreenViewModel: ObservableObject {
    @Published public var viewState: SearchScreenViewState = .initial
    @Published var searchQuery: String = ""
    @Published var debounceValue = ""
    @Published var sections: [SearchSection] = []
    private let dependencies: SearchScreenViewModelDependencies
    
    public init(dependencies: SearchScreenViewModelDependencies) {
        self.dependencies = dependencies
        $searchQuery
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .assign(to: &$debounceValue)
    }
    
    public func searchPodcasts(with query: String) async {
        await MainActor.run {
            viewState = .loading
        }
        
        do {
            let sections = try await dependencies.searchUseCase.search(with: query)
            await MainActor.run {
                self.sections = sections ?? []
                self.viewState = .loaded
            }
            
        } catch {
            let errorMessage = error.localizedDescription
            await MainActor.run {
                viewState = .error(errorMessage)
            }
        }
    }
}
