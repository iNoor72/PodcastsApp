//
//  IntegrationTestSearchUseCase.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 24/08/2025.
//

import Testing
import SwiftUI
import Combine
import Domain
@testable import SearchScreen

// MARK: - Integration Test Dependencies

@MainActor
final class IntegrationTestSearchUseCase: SearchUseCase {
    var mockData: [String: [SearchSection]] = [:]
    var shouldFail = false
    var failureError: Error = NSError(domain: "IntegrationTestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Integration test error"])
    var networkDelay: TimeInterval = 0
    var callHistory: [String] = []
    
    func search(with query: String) async throws -> [SearchSection]? {
        callHistory.append(query)
        
        if networkDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(networkDelay * 1_000_000_000))
        }
        
        if shouldFail {
            throw failureError
        }
        
        return mockData[query] ?? []
    }
    
    func setupMockData() {
        mockData = [
            "podcasts": [
                SearchTestDataFactory.createMockSearchSection(
                    id: "podcasts",
                    name: "Popular Podcasts",
                    type: .square,
                    contentCount: 5
                )
            ],
            "audiobooks": [
                SearchTestDataFactory.createMockSearchSection(
                    id: "audiobooks",
                    name: "Best Audiobooks",
                    type: .bigSquare,
                    contentCount: 3
                )
            ],
            "music": [
                SearchTestDataFactory.createMockSearchSection(
                    id: "music-podcasts",
                    name: "Music Podcasts",
                    type: .queue,
                    contentCount: 8
                ),
                SearchTestDataFactory.createMockSearchSection(
                    id: "music-shows",
                    name: "Music Shows",
                    type: .twoLinesGrid,
                    contentCount: 6
                )
            ],
            "": [] // Empty query
        ]
    }
    
    func reset() {
        mockData.removeAll()
        shouldFail = false
        networkDelay = 0
        callHistory.removeAll()
    }
}

// MARK: - Full Integration Tests

@Suite("SearchScreen Full Integration Tests")
@MainActor
struct SearchScreenFullIntegrationTests {
    
    // MARK: - End-to-End Flow Tests
    
    @Test("Complete search flow works end-to-end")
    func testCompleteSearchFlow() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        useCase.setupMockData()
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        let searchScreen = SearchScreen(viewModel: viewModel)
        
        // Initial state
        #expect(viewModel.viewState == .initial)
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.sections.isEmpty)
        #expect(!viewModel.isLoading)
        
        // Perform search
        await viewModel.searchPodcasts(with: "podcasts")
        
        // Verify results
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.count == 1)
        #expect(viewModel.sections[0].name == "Popular Podcasts")
        #expect(viewModel.sections[0].content.count == 5)
        #expect(!viewModel.isLoading)
        
        // Verify use case was called
        #expect(useCase.callHistory.contains("podcasts"))
    }
    
    @Test("Debounced search flow with rapid typing")
    func testDebouncedSearchFlow() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        useCase.setupMockData()
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Rapidly type search query
        viewModel.searchQuery = "p"
        viewModel.searchQuery = "po"
        viewModel.searchQuery = "pod"
        viewModel.searchQuery = "podc"
        viewModel.searchQuery = "podca"
        viewModel.searchQuery = "podcas"
        viewModel.searchQuery = "podcasts"
        
        // Wait for debounce
        try await Task.sleep(nanoseconds: 300_000_000) // 300ms
        
        #expect(viewModel.debounceValue == "podcasts")
    }
    
    @Test("Error handling flow with retry")
    func testErrorHandlingFlow() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        useCase.shouldFail = true
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        let searchScreen = SearchScreen(viewModel: viewModel)
        
        // Perform search that fails
        await viewModel.searchPodcasts(with: "failing query")
        
        // Verify error state
        switch viewModel.viewState {
        case .error(let message):
            #expect(message == "Integration test error")
        default:
            Issue.record("Expected error state")
        }
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.sections.isEmpty)
        
        // Retry with success
        useCase.shouldFail = false
        useCase.setupMockData()
        
        await viewModel.searchPodcasts(with: "podcasts")
        
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.count == 1)
    }
    
    @Test("Multiple search queries flow")
    func testMultipleSearchQueriesFlow() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        useCase.setupMockData()
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Search for podcasts
        await viewModel.searchPodcasts(with: "podcasts")
        #expect(viewModel.sections.count == 1)
        #expect(viewModel.sections[0].name == "Popular Podcasts")
        
        // Search for audiobooks
        await viewModel.searchPodcasts(with: "audiobooks")
        #expect(viewModel.sections.count == 1)
        #expect(viewModel.sections[0].name == "Best Audiobooks")
        
        // Search for music (multiple sections)
        await viewModel.searchPodcasts(with: "music")
        #expect(viewModel.sections.count == 2)
        #expect(viewModel.sections[0].name == "Music Podcasts")
        #expect(viewModel.sections[1].name == "Music Shows")
        
        // Verify all calls were made
        #expect(useCase.callHistory.count == 3)
        #expect(useCase.callHistory.contains("podcasts"))
        #expect(useCase.callHistory.contains("audiobooks"))
        #expect(useCase.callHistory.contains("music"))
    }
    
    // MARK: - Network Simulation Tests
    
    @Test("Slow network simulation")
    func testSlowNetworkSimulation() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        useCase.setupMockData()
        useCase.networkDelay = 1.0 // 1 second delay
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Start search
        let searchTask = Task {
            await viewModel.searchPodcasts(with: "podcasts")
        }
        
        // Check loading state immediately
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        #expect(viewModel.isLoading)
        
        // Wait for completion
        await searchTask.value
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.count == 1)
    }
    
    @Test("Network timeout simulation")
    func testNetworkTimeoutSimulation() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        
        let timeoutError = NSError(
            domain: "NetworkError",
            code: NSURLErrorTimedOut,
            userInfo: [NSLocalizedDescriptionKey: "Request timed out"]
        )
        useCase.failureError = timeoutError
        useCase.shouldFail = true
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        await viewModel.searchPodcasts(with: "timeout test")
        
        switch viewModel.viewState {
        case .error(let message):
            #expect(message == "Request timed out")
        default:
            Issue.record("Expected timeout error")
        }
    }
    
    // MARK: - Concurrent Operations Tests
    
    @Test("Concurrent searches are handled properly")
    func testConcurrentSearches() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        useCase.setupMockData()
        useCase.networkDelay = 0.5 // 500ms delay
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Start multiple concurrent searches
        async let search1 = viewModel.searchPodcasts(with: "podcasts")
        async let search2 = viewModel.searchPodcasts(with: "audiobooks")
        async let search3 = viewModel.searchPodcasts(with: "music")
        
        // Wait for all to complete
        await search1
        await search2
        await search3
        
        // Should have made all calls
        #expect(useCase.callHistory.count == 3)
        #expect(!viewModel.isLoading)
        #expect(viewModel.viewState == .loaded)
    }
    
    // MARK: - Data Consistency Tests
    
    @Test("Data consistency across view model and UI")
    func testDataConsistency() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        useCase.setupMockData()
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        let searchScreen = SearchScreen(viewModel: viewModel)
        
        // Perform search
        await viewModel.searchPodcasts(with: "music")
        
        // Verify data consistency
        let sections = viewModel.sections
        #expect(sections.count == 2)
        
        // Verify section data integrity
        for section in sections {
            #expect(!section.id.isEmpty)
            #expect(!section.name.isEmpty)
            
            for content in section.content {
                #expect(!content.id.isEmpty)
                #expect(!content.title.isEmpty)
                #expect(!content.imageURL.isEmpty)
            }
        }
    }
    
    // MARK: - State Persistence Tests
    
    @Test("Search state persists across view updates")
    func testSearchStatePersistence() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        useCase.setupMockData()
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Set search query and perform search
        viewModel.searchQuery = "persistent query"
        await viewModel.searchPodcasts(with: "podcasts")
        
        // Verify state is maintained
        #expect(viewModel.searchQuery == "persistent query")
        #expect(viewModel.viewState == .loaded)
        #expect(!viewModel.sections.isEmpty)
        
        // Trigger UI update (simulate view refresh)
        viewModel.objectWillChange.send()
        
        // State should still be maintained
        #expect(viewModel.searchQuery == "persistent query")
        #expect(viewModel.viewState == .loaded)
        #expect(!viewModel.sections.isEmpty)
    }
    
    // MARK: - Edge Case Integration Tests
    
    @Test("Empty search results integration")
    func testEmptySearchResultsIntegration() async throws {
        let coordinator = SearchCoordinator(path: [])
        let useCase = IntegrationTestSearchUseCase()
        
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: coordinator,
            searchUseCase: useCase
        )
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        let searchScreen = SearchScreen(viewModel: viewModel)
        
        // Search for non-existent content
        await viewModel.searchPodcasts(with: "nonexistent")
        
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.isEmpty)
        #expect(!viewModel.isLoading)
    }
}
