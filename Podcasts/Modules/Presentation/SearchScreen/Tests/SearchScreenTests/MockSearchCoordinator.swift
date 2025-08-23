//
//  MockSearchCoordinator.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 24/08/2025.
//

import Testing
import Foundation
import Domain
import Combine
@testable import SearchScreen

// MARK: - Mock Dependencies

@MainActor
final class MockSearchCoordinator: SearchCoordinatorProtocol {
    var navigationCallCount = 0
    var lastNavigationRoute: String?
    
    func navigate(to route: String) {
        navigationCallCount += 1
        lastNavigationRoute = route
    }
    
    func reset() {
        navigationCallCount = 0
        lastNavigationRoute = nil
    }
}

final class MockSearchUseCase: SearchUseCase {
    var searchResult: [SearchSection]?
    var shouldThrowError = false
    var errorToThrow: Error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock search error"])
    var searchCallCount = 0
    var lastSearchQuery: String?
    var searchDelay: TimeInterval = 0
    
    func search(with query: String) async throws -> [SearchSection]? {
        searchCallCount += 1
        lastSearchQuery = query
        
        if searchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(searchDelay * 1_000_000_000))
        }
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return searchResult
    }
    
    func reset() {
        searchResult = nil
        shouldThrowError = false
        searchCallCount = 0
        lastSearchQuery = nil
        searchDelay = 0
    }
}

// MARK: - Test Data Factory

struct SearchTestDataFactory {
    static func createMockSearchContent(
        id: String = "test-content",
        title: String = "Test Content"
    ) -> SearchContent {
        
        return SearchContent(podcastID: id, name: title, description: "", avatarURL: "", episodeCount: "", duration: "", language: "", priority: "", popularityScore: "", score: "")
    }
    
    static func createMockSearchSection(
        id: String = "test-section",
        name: String = "Test Section",
        type: SectionType = .square,
        contentCount: Int = 3
    ) -> SearchSection {
        let mockContent = (0..<contentCount).map { index in
            createMockSearchContent(
                id: "\(id)-content-\(index)",
                title: "Content \(index)"
            )
        }
        
        return SearchSection(name: name, type: type, contentType: "", order: "", content: [])
    }
    
    static func createMultipleMockSections() -> [SearchSection] {
        return [
            createMockSearchSection(id: "podcasts", name: "Podcasts", type: .square),
            createMockSearchSection(id: "audiobooks", name: "Audiobooks", type: .bigSquare),
            createMockSearchSection(id: "queue", name: "Queue", type: .queue),
            createMockSearchSection(id: "grid", name: "Grid Items", type: .twoLinesGrid)
        ]
    }
    
    static func createEmptySection() -> SearchSection {
        return SearchSection(name: "Empty Section", type: .square, contentType: "", order: "", content: [])
    }
}

// MARK: - SearchScreenViewModel Tests

@Suite("SearchScreenViewModel Tests")
@MainActor
struct SearchScreenViewModelTests {
    
    // MARK: - Initialization Tests
    
    @Test("ViewModel initializes with correct default state")
    func testViewModelInitialization() {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        #expect(viewModel.viewState == .initial)
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.debounceValue.isEmpty)
        #expect(viewModel.sections.isEmpty)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("ViewModel sets up debounce correctly")
    func testDebounceSetup() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Set search query
        viewModel.searchQuery = "test"
        
        // Wait for debounce delay (200ms + buffer)
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        #expect(viewModel.debounceValue == "test")
    }
    
    // MARK: - Search Functionality Tests
    
    @Test("Search with empty query returns empty sections")
    func testSearchWithEmptyQuery() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        useCase.searchResult = []
        
        await viewModel.searchPodcasts(with: "")
        
        #expect(useCase.searchCallCount == 1)
        #expect(useCase.lastSearchQuery == "")
        #expect(viewModel.sections.isEmpty)
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Search with valid query returns results")
    func testSearchWithValidQuery() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        let mockSections = SearchTestDataFactory.createMultipleMockSections()
        useCase.searchResult = mockSections
        
        await viewModel.searchPodcasts(with: "test query")
        
        #expect(useCase.searchCallCount == 1)
        #expect(useCase.lastSearchQuery == "test query")
        #expect(viewModel.sections.count == 4)
        #expect(viewModel.sections[0].name == "Podcasts")
        #expect(viewModel.sections[1].name == "Audiobooks")
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Search handles nil results gracefully")
    func testSearchWithNilResults() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        useCase.searchResult = nil
        
        await viewModel.searchPodcasts(with: "test query")
        
        #expect(viewModel.sections.isEmpty)
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Search handles error correctly")
    func testSearchWithError() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        let customError = NSError(domain: "CustomError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Custom error message"])
        useCase.errorToThrow = customError
        useCase.shouldThrowError = true
        
        await viewModel.searchPodcasts(with: "test query")
        
        #expect(viewModel.sections.isEmpty)
        #expect(viewModel.isLoading == false)
        
        switch viewModel.viewState {
        case .error(let errorMessage):
            #expect(errorMessage == "Custom error message")
        default:
            Issue.record("Expected error state but got \(viewModel.viewState)")
        }
    }
    
    @Test("Loading state is managed correctly during search")
    func testLoadingStateDuringSearch() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        useCase.searchDelay = 0.1 // 100ms delay
        useCase.searchResult = []
        
        // Start search without awaiting
        let searchTask = Task {
            await viewModel.searchPodcasts(with: "test")
        }
        
        // Give a moment for the search to start
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        
        // Check that loading is true
        #expect(viewModel.isLoading == true)
        
        // Wait for search to complete
        await searchTask.value
        
        // Loading should be false after completion
        #expect(viewModel.isLoading == false)
    }
    
    // MARK: - Debounce Behavior Tests
    
    @Test("Debounce value updates after specified delay")
    func testDebounceValueUpdate() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        #expect(viewModel.debounceValue.isEmpty)
        
        viewModel.searchQuery = "test"
        
        // Should not update immediately
        #expect(viewModel.debounceValue.isEmpty)
        
        // Wait for debounce delay
        try? await Task.sleep(nanoseconds: 250_000_000) // 250ms
        
        #expect(viewModel.debounceValue == "test")
    }
    
    @Test("Multiple rapid changes only trigger final debounced value")
    func testDebounceMultipleRapidChanges() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Rapidly change search query
        viewModel.searchQuery = "a"
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        viewModel.searchQuery = "ab"
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        viewModel.searchQuery = "abc"
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        viewModel.searchQuery = "abcd"
        
        // Wait for debounce
        try? await Task.sleep(nanoseconds: 250_000_000) // 250ms
        
        #expect(viewModel.debounceValue == "abcd")
    }
    
    // MARK: - State Management Tests
    
    @Test("View state transitions from initial to loaded")
    func testViewStateInitialToLoaded() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        #expect(viewModel.viewState == .initial)
        
        useCase.searchResult = []
        await viewModel.searchPodcasts(with: "test")
        
        #expect(viewModel.viewState == .loaded)
    }
    
    @Test("View state transitions from loaded to error")
    func testViewStateLoadedToError() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // First successful search
        useCase.searchResult = []
        await viewModel.searchPodcasts(with: "test")
        #expect(viewModel.viewState == .loaded)
        
        // Then failed search
        useCase.shouldThrowError = true
        await viewModel.searchPodcasts(with: "test2")
        
        switch viewModel.viewState {
        case .error:
            // Expected
            break
        default:
            Issue.record("Expected error state but got \(viewModel.viewState)")
        }
    }
    
    @Test("View state transitions from error to loaded")
    func testViewStateErrorToLoaded() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // First failed search
        useCase.shouldThrowError = true
        await viewModel.searchPodcasts(with: "test")
        
        switch viewModel.viewState {
        case .error:
            break
        default:
            Issue.record("Expected error state")
        }
        
        // Then successful search
        useCase.shouldThrowError = false
        useCase.searchResult = []
        await viewModel.searchPodcasts(with: "test2")
        
        #expect(viewModel.viewState == .loaded)
    }
    
    // MARK: - Edge Cases
    
    @Test("Search with whitespace-only query")
    func testSearchWithWhitespaceQuery() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        let whitespaceQuery = "   \t\n  "
        useCase.searchResult = []
        
        await viewModel.searchPodcasts(with: whitespaceQuery)
        
        #expect(useCase.lastSearchQuery == whitespaceQuery)
        #expect(viewModel.viewState == .loaded)
    }
    
    @Test("Search with very long query")
    func testSearchWithVeryLongQuery() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        let longQuery = String(repeating: "a", count: 10000)
        useCase.searchResult = []
        
        await viewModel.searchPodcasts(with: longQuery)
        
        #expect(useCase.lastSearchQuery == longQuery)
        #expect(viewModel.viewState == .loaded)
    }
    
    @Test("Search with special characters and emojis")
    func testSearchWithSpecialCharactersAndEmojis() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        let specialQuery = "!@#$%^&*()_+{}[]|\\:;\"'<>?,./ 🎵🎧📻 العربية 中文 Español"
        useCase.searchResult = []
        
        await viewModel.searchPodcasts(with: specialQuery)
        
        #expect(useCase.lastSearchQuery == specialQuery)
        #expect(viewModel.viewState == .loaded)
    }
    
    @Test("Search with different section types")
    func testSearchWithDifferentSectionTypes() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        let sectionsWithAllTypes = [
            SearchTestDataFactory.createMockSearchSection(type: .square),
            SearchTestDataFactory.createMockSearchSection(type: .bigSquare),
            SearchTestDataFactory.createMockSearchSection(type: .audiobookBigSquare),
            SearchTestDataFactory.createMockSearchSection(type: .queue),
            SearchTestDataFactory.createMockSearchSection(type: .twoLinesGrid)
        ]
        
        useCase.searchResult = sectionsWithAllTypes
        
        await viewModel.searchPodcasts(with: "test")
        
        #expect(viewModel.sections.count == 5)
        #expect(viewModel.sections[0].type == .square)
        #expect(viewModel.sections[1].type == .bigSquare)
        #expect(viewModel.sections[2].type == .audiobookBigSquare)
        #expect(viewModel.sections[3].type == .queue)
        #expect(viewModel.sections[4].type == .twoLinesGrid)
    }
    
    // MARK: - Concurrent Access Tests
    
    @Test("Multiple concurrent searches are handled properly")
    func testMultipleConcurrentSearches() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        useCase.searchResult = []
        useCase.searchDelay = 0.1
        
        // Start multiple searches concurrently
        async let search1 = viewModel.searchPodcasts(with: "query1")
        async let search2 = viewModel.searchPodcasts(with: "query2")
        async let search3 = viewModel.searchPodcasts(with: "query3")
        
        await search1
        await search2
        await search3
        
        #expect(useCase.searchCallCount == 3)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.viewState == .loaded)
    }
    
    @Test("Search cancellation behavior")
    func testSearchCancellationBehavior() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        useCase.searchResult = []
        useCase.searchDelay = 0.5 // Long delay
        
        // Start a search
        let searchTask = Task {
            await viewModel.searchPodcasts(with: "slow query")
        }
        
        // Start another search quickly
        await viewModel.searchPodcasts(with: "fast query")
        
        // Cancel the first search
        searchTask.cancel()
        
        // Should still be in valid state
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
    }
    
    // MARK: - Memory and Performance Tests
    
    @Test("ViewModel handles large result sets")
    func testLargeResultSets() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Create large result set
        let largeSections = (0..<1000).map { index in
            SearchTestDataFactory.createMockSearchSection(
                id: "section-\(index)",
                name: "Section \(index)",
                contentCount: 100
            )
        }
        
        useCase.searchResult = largeSections
        
        await viewModel.searchPodcasts(with: "large test")
        
        #expect(viewModel.sections.count == 1000)
        #expect(viewModel.sections.first?.content.count == 0)
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("ViewModel handles empty sections gracefully")
    func testEmptySectionsHandling() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        let emptySections = [
            SearchTestDataFactory.createEmptySection(),
            SearchTestDataFactory.createMockSearchSection(contentCount: 0)
        ]
        
        useCase.searchResult = emptySections
        
        await viewModel.searchPodcasts(with: "empty test")
        
        #expect(viewModel.sections.count == 2)
        #expect(viewModel.sections[0].content.isEmpty)
        #expect(viewModel.sections[1].content.isEmpty)
        #expect(viewModel.viewState == .loaded)
    }
    
    // MARK: - Protocol Conformance Tests
    
    @Test("ViewModel conforms to SearchViewModelProtocol")
    func testProtocolConformance() {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        #expect(viewModel is SearchViewModelProtocol)
    }
    
    @Test("ViewModel conforms to ObservableObject")
    func testObservableObjectConformance() {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        #expect(viewModel is (any ObservableObject))
    }
    
    // MARK: - Dependencies Tests
    
    @Test("Dependencies are properly stored and accessible")
    func testDependenciesStorage() async {
        let coordinator = MockSearchCoordinator()
        let useCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(coordinator: coordinator, searchUseCase: useCase)
        
        #expect(dependencies.coordinator === coordinator)
        #expect(dependencies.searchUseCase === useCase)
        
        let viewModel = SearchScreenViewModel(dependencies: dependencies)
        
        // Test that dependencies are used correctly
        useCase.searchResult = []
        await viewModel.searchPodcasts(with: "test")
        
        #expect(useCase.searchCallCount == 1)
    }
}

// MARK: - SearchScreenViewState Tests

@Suite("SearchScreenViewState Tests")
struct SearchScreenViewStateTests {
    
    @Test("ViewState cases are Hashable")
    func testViewStateHashable() {
        let initialState1 = SearchScreenViewState.initial
        let initialState2 = SearchScreenViewState.initial
        let loadedState = SearchScreenViewState.loaded
        let errorState = SearchScreenViewState.error("test")
        
        #expect(initialState1.hashValue == initialState2.hashValue)
        #expect(initialState1.hashValue != loadedState.hashValue)
        #expect(initialState1.hashValue != errorState.hashValue)
    }
    
    @Test("ViewState cases are Equatable")
    func testViewStateEquatable() {
        let initialState1 = SearchScreenViewState.initial
        let initialState2 = SearchScreenViewState.initial
        let loadedState = SearchScreenViewState.loaded
        let errorState1 = SearchScreenViewState.error("test")
        let errorState2 = SearchScreenViewState.error("test")
        let errorState3 = SearchScreenViewState.error("different")
        
        #expect(initialState1 == initialState2)
        #expect(initialState1 != loadedState)
        #expect(errorState1 == errorState2)
        #expect(errorState1 != errorState3)
    }
}
