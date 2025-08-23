//
//  SearchScreenViewModel.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Foundation
import Domain

public struct SearchScreenViewModelDependencies {
    let coordinator: SearchCoordinatorProtocol
    let searchUseCase: SearchUseCase
    
    public init(coordinator: SearchCoordinatorProtocol, searchUseCase: SearchUseCase) {
        self.coordinator = coordinator
        self.searchUseCase = searchUseCase
    }
}

@frozen public enum SearchScreenViewState: Hashable {
    case initial
    case loaded
    case error(String)
}

@MainActor
public final class SearchScreenViewModel: ObservableObject, SearchViewModelProtocol {
    @Published public var viewState: SearchScreenViewState = .initial
    @Published public var searchQuery: String = ""
    @Published public var debounceValue = ""
    @Published var sections: [SearchSection] = []
    @Published public var isLoading: Bool = false
    private let dependencies: SearchScreenViewModelDependencies
    
    public init(dependencies: SearchScreenViewModelDependencies) {
        self.dependencies = dependencies
        $searchQuery
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .assign(to: &$debounceValue)
    }
    
    public func searchPodcasts(with query: String) async {
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            let sections = try await dependencies.searchUseCase.search(with: query)
            await MainActor.run {
                self.sections = sections ?? []
                self.viewState = .loaded
                self.isLoading = false
            }
            
        } catch {
            let errorMessage = error.localizedDescription
            await MainActor.run {
                self.isLoading = false
                viewState = .error(errorMessage)
            }
        }
    }
}
