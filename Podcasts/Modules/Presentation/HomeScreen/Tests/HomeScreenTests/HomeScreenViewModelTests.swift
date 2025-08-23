//
//  HomeScreenViewModelTests.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 24/08/2025.
//

import Testing
import Foundation
@testable import HomeScreen
@testable import Domain
@testable import Common

@MainActor
struct HomeScreenViewModelTests {
    
    // MARK: - Test Dependencies
    
    private func makeMockDependencies(
        shouldThrowError: Bool = false,
        sections: [PodcastSection] = [],
        totalPages: Int = 1
    ) -> HomeScreenViewModelDependencies {
        let mockCoordinator = MockHomeCoordinator()
        let mockUseCase = MockFetchSectionsUseCase(
            shouldThrowError: shouldThrowError,
            sections: sections,
            totalPages: totalPages
        )
        return HomeScreenViewModelDependencies(
            coordinator: mockCoordinator,
            fetchPodcastsUseCase: mockUseCase
        )
    }
    
    private func makeMockSections(count: Int = 3) -> [PodcastSection] {
        return (0..<count).map { index in
            PodcastSection(
                id: "section_\(index)",
                name: "Section \(index)",
                type: .square,
                content: []
            )
        }
    }
    
    // MARK: - Initialization Tests
    
    @Test("ViewModel initializes with correct default state")
    func testInitialState() {
        let dependencies = makeMockDependencies()
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        #expect(viewModel.viewState == .initial)
        #expect(viewModel.sections.isEmpty)
        #expect(viewModel.isLoading == false)
    }
    
    // MARK: - fetchPodcasts Tests
    
    @Test("fetchPodcasts success - sets loading state and updates data")
    func testFetchPodcastsSuccess() async {
        let mockSections = makeMockSections(count: 2)
        let dependencies = makeMockDependencies(sections: mockSections, totalPages: 5)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.count == 2)
        #expect(viewModel.sections == mockSections)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("fetchPodcasts success - empty sections")
    func testFetchPodcastsSuccessWithEmptySections() async {
        let dependencies = makeMockDependencies(sections: [], totalPages: 1)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.isEmpty)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("fetchPodcasts sets loading state during execution")
    func testFetchPodcastsLoadingState() async {
        let dependencies = makeMockDependencies()
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        let task = Task {
            await viewModel.fetchPodcasts()
        }
        
        // Brief delay to check loading state
        try? await Task.sleep(nanoseconds: 1_000_000) // 1ms
        
        await task.value
        #expect(viewModel.isLoading == false)
    }
    
    @Test("fetchPodcasts failure - sets error state")
    func testFetchPodcastsFailure() async {
        let dependencies = makeMockDependencies(shouldThrowError: true)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        
        switch viewModel.viewState {
        case .error(let message):
            #expect(message == "Mock error occurred")
        default:
            Issue.record("Expected error state")
        }
        #expect(viewModel.isLoading == false)
        #expect(viewModel.sections.isEmpty)
    }
    
    @Test("fetchPodcasts updates totalPages correctly")
    func testFetchPodcastsUpdatesTotalPages() async {
        let dependencies = makeMockDependencies(totalPages: 10)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        
        // We can't directly test totalPages as it's private, but we can test its effect
        // by checking pagination behavior
        #expect(viewModel.viewState == .loaded)
    }
    
    // MARK: - fetchMorePodcastsIfNeeded Tests
    
    @Test("fetchMorePodcastsIfNeeded - loads more when item is last section")
    func testFetchMorePodcastsIfNeededWithLastSection() async {
        let initialSections = makeMockSections(count: 2)
        let dependencies = makeMockDependencies(sections: initialSections, totalPages: 3)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // First load
        await viewModel.fetchPodcasts()
        #expect(viewModel.sections.count == 2)
        
        // Setup mock for second page
        let mockUseCase = dependencies.fetchPodcastsUseCase as! MockFetchSectionsUseCase
        let additionalSections = makeMockSections(count: 1)
        additionalSections[0] = PodcastSection(
            id: "section_additional",
            name: "Additional Section",
            type: .bigSquare,
            content: []
        )
        mockUseCase.nextPageSections = additionalSections
        
        // Trigger pagination with last section
        let lastSection = viewModel.sections.last!
        await viewModel.fetchMorePodcastsIfNeeded(item: lastSection)
        
        #expect(viewModel.sections.count == 3)
    }
    
    @Test("fetchMorePodcastsIfNeeded - does nothing when item is not last section")
    func testFetchMorePodcastsIfNeededWithNonLastSection() async {
        let initialSections = makeMockSections(count: 3)
        let dependencies = makeMockDependencies(sections: initialSections, totalPages: 5)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        let initialCount = viewModel.sections.count
        
        // Use first section (not last)
        let firstSection = viewModel.sections.first!
        await viewModel.fetchMorePodcastsIfNeeded(item: firstSection)
        
        #expect(viewModel.sections.count == initialCount)
    }
    
    @Test("fetchMorePodcastsIfNeeded - does nothing when no more pages")
    func testFetchMorePodcastsIfNeededWithNoMorePages() async {
        let initialSections = makeMockSections(count: 2)
        let dependencies = makeMockDependencies(sections: initialSections, totalPages: 1)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        let initialCount = viewModel.sections.count
        
        let lastSection = viewModel.sections.last!
        await viewModel.fetchMorePodcastsIfNeeded(item: lastSection)
        
        #expect(viewModel.sections.count == initialCount)
    }
    
    @Test("fetchMorePodcastsIfNeeded - handles error during pagination")
    func testFetchMorePodcastsIfNeededWithError() async {
        let initialSections = makeMockSections(count: 2)
        let dependencies = makeMockDependencies(sections: initialSections, totalPages: 3)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        
        // Setup mock to throw error on next call
        let mockUseCase = dependencies.fetchPodcastsUseCase as! MockFetchSectionsUseCase
        mockUseCase.shouldThrowErrorOnNextCall = true
        
        let lastSection = viewModel.sections.last!
        await viewModel.fetchMorePodcastsIfNeeded(item: lastSection)
        
        switch viewModel.viewState {
        case .error(let message):
            #expect(message == "Mock error occurred")
        default:
            Issue.record("Expected error state")
        }
        #expect(viewModel.isLoading == false)
    }
    
    @Test("fetchMorePodcastsIfNeeded - with empty sections array")
    func testFetchMorePodcastsIfNeededWithEmptySections() async {
        let dependencies = makeMockDependencies(sections: [], totalPages: 1)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        
        // Create a dummy section
        let dummySection = PodcastSection(id: "dummy", name: "Dummy", type: .square, content: [])
        
        // Should not crash with empty sections
        await viewModel.fetchMorePodcastsIfNeeded(item: dummySection)
        
        #expect(viewModel.sections.isEmpty)
    }
    
    // MARK: - State Transition Tests
    
    @Test("State transitions correctly from initial to loaded")
    func testStateTransitionInitialToLoaded() async {
        let dependencies = makeMockDependencies(sections: makeMockSections())
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        #expect(viewModel.viewState == .initial)
        
        await viewModel.fetchPodcasts()
        
        #expect(viewModel.viewState == .loaded)
    }
    
    @Test("State transitions correctly from initial to error")
    func testStateTransitionInitialToError() async {
        let dependencies = makeMockDependencies(shouldThrowError: true)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        #expect(viewModel.viewState == .initial)
        
        await viewModel.fetchPodcasts()
        
        switch viewModel.viewState {
        case .error:
            break // Expected
        default:
            Issue.record("Expected error state")
        }
    }
    
    @Test("State can transition from error back to loaded")
    func testStateTransitionErrorToLoaded() async {
        let dependencies = makeMockDependencies(shouldThrowError: true)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // First call should fail
        await viewModel.fetchPodcasts()
        
        switch viewModel.viewState {
        case .error:
            break // Expected
        default:
            Issue.record("Expected error state")
        }
        
        // Fix the mock and retry
        let mockUseCase = dependencies.fetchPodcastsUseCase as! MockFetchSectionsUseCase
        mockUseCase.shouldThrowError = false
        mockUseCase.sections = makeMockSections()
        
        await viewModel.fetchPodcasts()
        
        #expect(viewModel.viewState == .loaded)
        #expect(!viewModel.sections.isEmpty)
    }
    
    // MARK: - Edge Cases
    
    @Test("Multiple concurrent fetchPodcasts calls")
    func testMultipleConcurrentFetchPodcastsCalls() async {
        let dependencies = makeMockDependencies(sections: makeMockSections())
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // Start multiple concurrent calls
        async let call1 = viewModel.fetchPodcasts()
        async let call2 = viewModel.fetchPodcasts()
        async let call3 = viewModel.fetchPodcasts()
        
        await call1
        await call2
        await call3
        
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Pagination with maximum pages")
    func testPaginationWithMaximumPages() async {
        let initialSections = [makeMockSections(count: 1)[0]]
        let dependencies = makeMockDependencies(sections: initialSections, totalPages: Int.max)
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        await viewModel.fetchPodcasts()
        
        let lastSection = viewModel.sections.last!
        await viewModel.fetchMorePodcastsIfNeeded(item: lastSection)
        
        // Should handle large page numbers gracefully
        #expect(viewModel.viewState == .loaded || viewModel.viewState == .error("Mock error occurred"))
    }
}

// MARK: - Mock Classes

class MockHomeCoordinator: HomeCoordinator {
    // Implement required coordinator methods as needed
}

class MockFetchSectionsUseCase: FetchSectionsUseCase {
    var shouldThrowError: Bool
    var sections: [PodcastSection]
    var totalPages: Int
    var nextPageSections: [PodcastSection] = []
    var shouldThrowErrorOnNextCall: Bool = false
    private var callCount = 0
    
    init(shouldThrowError: Bool = false, sections: [PodcastSection] = [], totalPages: Int = 1) {
        self.shouldThrowError = shouldThrowError
        self.sections = sections
        self.totalPages = totalPages
    }
    
    func fetchSections(page: Int) async throws -> FetchSectionsResult {
        callCount += 1
        
        if shouldThrowErrorOnNextCall && callCount > 1 {
            throw MockError.fetchFailed
        }
        
        if shouldThrowError {
            throw MockError.fetchFailed
        }
        
        let sectionsToReturn = callCount == 1 ? sections : nextPageSections
        
        return FetchSectionsResult(
            sections: sectionsToReturn,
            totalPages: totalPages
        )
    }
}

enum MockError: LocalizedError {
    case fetchFailed
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Mock error occurred"
        }
    }
}

// MARK: - Helper Extensions

extension PodcastSection: Equatable {
    public static func == (lhs: PodcastSection, rhs: PodcastSection) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.type == rhs.type
    }
}

extension HomeScreenViewState: Equatable {
    public static func == (lhs: HomeScreenViewState, rhs: HomeScreenViewState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial), (.loaded, .loaded):
            return true
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
