//
//  SearchScreenViewModel.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Foundation
import Domain

public struct SearchScreenViewModelDependencies: Sendable {
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
    private let dependencies: SearchScreenViewModelDependencies
    private var currentPage = 1
    private var finalPage = 0
    var sections: [PodcastSection] = []
    
    public init(dependencies: SearchScreenViewModelDependencies) {
        self.dependencies = dependencies
    }
    
    public func searchPodcasts(with query: String) async {
        viewState = .loading
        
        do {
            let sections = try await dependencies.searchUseCase.search(with: query)
            self.viewState = .loaded
            
        } catch {
            let errorMessage = error.localizedDescription
            viewState = .error(errorMessage)
        }
    }
    
//    @MainActor
//    public func fetchMorePodcasts() async {
//        if currentPage < finalPage {
//            currentPage += 1
//            do {
//                let sections = try await dependencies.searchUseCase.search(with: query)
//                self.sections.append(contentsOf: sections)
//            } catch {
//                let errorMessage = error.localizedDescription
//                await MainActor.run {
//                    viewState = .error(errorMessage)
//                }
//            }
//        }
//    }
}
