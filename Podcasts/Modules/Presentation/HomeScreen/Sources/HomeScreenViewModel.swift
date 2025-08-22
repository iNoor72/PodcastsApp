//
//  HomeScreenViewModel.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Foundation
import Domain

public struct HomeScreenViewModelDependencies: Sendable {
    let coordinator: HomeCoordinator
    let fetchPodcastsUseCase: FetchSectionsUseCase
    
    public init(coordinator: HomeCoordinator, fetchPodcastsUseCase: FetchSectionsUseCase) {
        self.coordinator = coordinator
        self.fetchPodcastsUseCase = fetchPodcastsUseCase
    }
}

@frozen public enum HomeScreenViewState: Hashable {
    case initial
    case loading
    case loaded
    case error(String)
}

@MainActor
public final class HomeScreenViewModel: ObservableObject {
    @Published public var viewState: HomeScreenViewState = .initial
    private let dependencies: HomeScreenViewModelDependencies
    private var currentPage = 1
    private var finalPage = 0
    var sections: [PodcastSection] = []
    
    public init(dependencies: HomeScreenViewModelDependencies) {
        self.dependencies = dependencies
    }
    
    public func fetchPodcasts() async {
        viewState = .loading
        
        do {
            let sections = try await dependencies.fetchPodcastsUseCase.fetchSections(page: currentPage)
            self.sections = sections
            self.finalPage = 10
            self.viewState = .loaded
            
        } catch {
            let errorMessage = error.localizedDescription
            viewState = .error(errorMessage)
        }
    }
    
    @MainActor
    public func fetchMorePodcasts() async {
        if currentPage < finalPage {
            currentPage += 1
            do {
                let sections = try await dependencies.fetchPodcastsUseCase.fetchSections(page: currentPage)
                self.sections.append(contentsOf: sections)
            } catch {
                let errorMessage = error.localizedDescription
                await MainActor.run {
                    viewState = .error(errorMessage)
                }
            }
        }
    }
    
    public func searchButtonTapped() {
        
    }
}
