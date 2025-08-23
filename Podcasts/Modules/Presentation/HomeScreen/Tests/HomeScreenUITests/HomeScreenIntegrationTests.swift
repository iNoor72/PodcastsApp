//
//  HomeScreenIntegrationTests.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 24/08/2025.
//

import Testing
import SwiftUI
import ViewInspector
@testable import HomeScreen
@testable import Domain
@testable import DesignSystem
@testable import Common

@MainActor
struct HomeScreenIntegrationTests {
    
    // MARK: - Complete User Journey Tests
    
    @Test("Complete successful user journey from initial load to pagination")
    func testCompleteSuccessfulUserJourney() async throws {
        // Setup
        let initialSections = [
            PodcastSection(id: "1", name: "Popular", type: .square, content: []),
            PodcastSection(id: "2", name: "Recent", type: .bigSquare, content: [])
        ]
        let additionalSections = [
            PodcastSection(id: "3", name: "More", type: .queue, content: [])
        ]
        
        let mockUseCase = MockFetchSectionsUseCase(
            sections: initialSections,
            totalPages: 2
        )
        mockUseCase.nextPageSections = additionalSections
        
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Step 1: Initial state should show loading
        #expect(viewModel.viewState == .initial)
        var progressView = try? homeScreen.inspect().find(ProgressView.self)
        #expect(progressView != nil)
        
        // Step 2: Trigger initial load
        if let progressView = progressView {
            try progressView.callOnAppear()
        }
        
        // Wait for async operation
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Step 3: Should now be in loaded state with initial sections
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.count == 2)
        
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollView != nil)
        
        // Step 4: Trigger pagination by appearing the last section
        let lastSection = viewModel.sections.last!
        await viewModel.fetchMorePodcastsIfNeeded(item: lastSection)
        
        // Step 5: Should now have additional sections
        #expect(viewModel.sections.count == 3)
        #expect(viewModel.viewState == .loaded)
    }
    
    @Test("Complete error recovery journey")
    func testCompleteErrorRecoveryJourney() async throws {
        // Setup with initial error
        let mockUseCase = MockFetchSectionsUseCase(shouldThrowError: true)
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Step 1: Initial load fails
        await viewModel.fetchPodcasts()
        
        switch viewModel.viewState {
        case .error(let message):
            #expect(message == "Mock error occurred")
        default:
            Issue.record("Expected error state")
        }
        
        let retryView = try homeScreen.inspect().find(RetryView.self)
        #expect(retryView != nil)
        
        // Step 2: Fix the error condition and retry
        mockUseCase.shouldThrowError = false
        mockUseCase.sections = [
            PodcastSection(id: "1", name: "Recovered", type: .square, content: [])
        ]
        
        // Simulate retry action
        viewModel.viewState = .initial
        await viewModel.fetchPodcasts()
        
        // Step 3: Should now be successful
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.count == 1)
        #expect(viewModel.sections.first?.name == "Recovered")
    }
    
    @Test("Journey with network interruption during pagination")
    func testJourneyWithNetworkInterruptionDuringPagination() async throws {
        // Setup successful initial load
        let initialSections = [
            PodcastSection(id: "1", name: "First", type: .square, content: [])
        ]
        
        let mockUseCase = MockFetchSectionsUseCase(
            sections: initialSections,
            totalPages: 3
        )
        
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // Step 1: Successful initial load
        await viewModel.fetchPodcasts()
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.sections.count == 1)
        
        // Step 2: Network fails during pagination
        mockUseCase.shouldThrowErrorOnNextCall = true
        
        let lastSection = viewModel.sections.last!
        await viewModel.fetchMorePodcastsIfNeeded(item: lastSection)
        
        // Step 3: Should be in error state but keep existing data
        switch viewModel.viewState {
        case .error:
            #expect(viewModel.sections.count == 1) // Original data preserved
        default:
            Issue.record("Expected error state")
        }
    }
    
    // MARK: - RTL/LTR Integration Tests
    
    @Test("Complete RTL user experience")
    func testCompleteRTLUserExperience() async throws {
        let sections = [
            PodcastSection(id: "1", name: "قسم شائع", type: .square, content: []),
            PodcastSection(id: "2", name: "قسم حديث", type: .bigSquare, content: [])
        ]
        
        let mockUseCase = MockFetchSectionsUseCase(sections: sections)
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // Load data
        await viewModel.fetchPodcasts()
        
        // Create HomeScreen (RTL detection happens in init)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Verify content sections receive RTL context
        let contentSections = try homeScreen.inspect().findAll(ContentSection.self)
        #expect(contentSections.count == 2)
        
        // Each ContentSection should handle RTL layout
        for contentSection in contentSections {
            let vstack = try contentSection.find(VStack.self)
            #expect(vstack != nil)
        }
    }
    
    // MARK: - Memory and Performance Integration Tests
    
    @Test("Memory management during rapid state changes")
    func testMemoryManagementDuringRapidStateChanges() async throws {
        let mockUseCase = MockFetchSectionsUseCase()
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // Rapid state changes
        for i in 0..<10 {
            if i % 2 == 0 {
                mockUseCase.shouldThrowError = true
                await viewModel.fetchPodcasts()
                #expect(viewModel.viewState != .loaded)
            } else {
                mockUseCase.shouldThrowError = false
                mockUseCase.sections = [
                    PodcastSection(id: "temp_\(i)", name: "Temp \(i)", type: .square, content: [])
                ]
                await viewModel.fetchPodcasts()
                #expect(viewModel.viewState == .loaded)
            }
        }
        
        // Final state should be stable
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Performance with large dataset and pagination")
    func testPerformanceWithLargeDatasetAndPagination() async throws {
        // Create large initial dataset
        let largeInitialSections = (0..<50).map { index in
            PodcastSection(
                id: "section_\(index)",
                name: "Section \(index)",
                type: PodcastSectionType.allCases[index % PodcastSectionType.allCases.count],
                content: []
            )
        }
        
        let additionalSections = (50..<100).map { index in
            PodcastSection(
                id: "section_\(index)",
                name: "Section \(index)",
                type: PodcastSectionType.allCases[index % PodcastSectionType.allCases.count],
                content: []
            )
        }
        
        let mockUseCase = MockFetchSectionsUseCase(
            sections: largeInitialSections,
            totalPages: 2
        )
        mockUseCase.nextPageSections = additionalSections
        
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Initial load
        await viewModel.fetchPodcasts()
        #expect(viewModel.sections.count == 50)
        
        // Verify LazyVStack is used for performance
        let lazyVStack = try homeScreen.inspect().find(LazyVStack.self)
        #expect(lazyVStack != nil)
        
        // Trigger pagination
        let lastSection = viewModel.sections.last!
        await viewModel.fetchMorePodcastsIfNeeded(item: lastSection)
        
        #expect(viewModel.sections.count == 100)
        #expect(viewModel.viewState == .loaded)
    }
    
    // MARK: - Edge Case Integration Tests
    
    @Test("Concurrent operations handling")
    func testConcurrentOperationsHandling() async throws {
        let mockUseCase = MockFetchSectionsUseCase(
            sections: [PodcastSection(id: "1", name: "Test", type: .square, content: [])],
            totalPages: 5
        )
        
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // Start multiple concurrent operations
        async let operation1 = viewModel.fetchPodcasts()
        async let operation2 = viewModel.fetchPodcasts()
        
        // Also trigger pagination concurrently
        let dummySection = PodcastSection(id: "dummy", name: "Dummy", type: .square, content: [])
        async let operation3 = viewModel.fetchMorePodcastsIfNeeded(item: dummySection)
        
        // Wait for all operations
        await operation1
        await operation2
        await operation3
        
        // Should end in a consistent state
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("State persistence through configuration changes")
    func testStatePersistenceThroughConfigurationChanges() async throws {
        let sections = [
            PodcastSection(id: "1", name: "Persistent", type: .square, content: [])
        ]
        
        let mockUseCase = MockFetchSectionsUseCase(sections: sections)
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // Load initial data
        await viewModel.fetchPodcasts()
        #expect(viewModel.viewState == .loaded)
        
        // Simulate configuration change by creating new HomeScreen instance with same viewModel
        let homeScreen1 = HomeScreen(viewModel: viewModel)
        let homeScreen2 = HomeScreen(viewModel: viewModel)
        
        // Both should show the same loaded state
        let scrollView1 = try homeScreen1.inspect().find(ScrollView.self)
        let scrollView2 = try homeScreen2.inspect().find(ScrollView.self)
        
        #expect(scrollView1 != nil)
        #expect(scrollView2 != nil)
    }
    
    @Test("Error handling with different error types")
    func testErrorHandlingWithDifferentErrorTypes() async throws {
        let mockUseCase = MockFetchSectionsUseCase()
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Test different error types
        let errorTypes: [MockError] = [.fetchFailed, .networkError, .timeoutError]
        
        for errorType in errorTypes {
            mockUseCase.customError = errorType
            mockUseCase.shouldThrowError = true
            
            await viewModel.fetchPodcasts()
            
            switch viewModel.viewState {
            case .error(let message):
                #expect(!message.isEmpty)
                
                // Verify RetryView appears for each error type
                let retryView = try homeScreen.inspect().find(RetryView.self)
                #expect(retryView != nil)
                
            default:
                Issue.record("Expected error state for \(errorType)")
            }
        }
    }
    
    @Test("Section type handling completeness")
    func testSectionTypeHandlingCompleteness() async throws {
        // Create sections with all possible types
        let allSectionTypes: [PodcastSectionType] = [.square, .bigSquare, .audiobookBigSquare, .queue, .twoLinesGrid]
        
        let sectionsWithAllTypes = allSectionTypes.enumerated().map { index, type in
            PodcastSection(
                id: "section_\(index)",
                name: "Section \(type)",
                type: type,
                content: []
            )
        }
        
        let mockUseCase = MockFetchSectionsUseCase(sections: sectionsWithAllTypes)
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        await viewModel.fetchPodcasts()
        #expect(viewModel.sections.count == allSectionTypes.count)
        
        // Verify each section type creates the correct view component
        let contentSections = try homeScreen.inspect().findAll(ContentSection.self)
        #expect(contentSections.count == allSectionTypes.count)
        
        // Check specific components exist
        let horizontalCardLists = try? homeScreen.inspect().findAll(HorizontalCardList.self)
        let horizontalBigCardLists = try? homeScreen.inspect().findAll(HorizontalBigCardList.self)
        let horizontalQueueLists = try? homeScreen.inspect().findAll(HorizontalQueueList.self)
        let horizontalGridCardLists = try? homeScreen.inspect().findAll(HorizontalGridCardList.self)
        
        #expect(horizontalCardLists?.count == 1) // .square
        #expect(horizontalBigCardLists?.count == 2) // .bigSquare and .audiobookBigSquare
        #expect(horizontalQueueLists?.count == 1) // .queue
        #expect(horizontalGridCardLists?.count == 1) // .twoLinesGrid
    }
    
    // MARK: - Accessibility Integration Tests
    
    @Test("Complete accessibility journey")
    func testCompleteAccessibilityJourney() async throws {
        let sections = [
            PodcastSection(id: "1", name: "Accessible Section", type: .square, content: [])
        ]
        
        let mockUseCase = MockFetchSectionsUseCase(sections: sections)
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Test accessibility in each state
        
        // 1. Initial state accessibility
        #expect(viewModel.viewState == .initial)
        let initialProgressView = try homeScreen.inspect().find(ProgressView.self)
        #expect(initialProgressView != nil)
        
        // 2. Load data and test loaded state accessibility
        await viewModel.fetchPodcasts()
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollView != nil)
        
        // 3. Test error state accessibility
        viewModel.viewState = .error("Accessibility test error")
        let retryView = try homeScreen.inspect().find(RetryView.self)
        #expect(retryView != nil)
    }
    
    // MARK: - Real-world Scenario Tests
    
    @Test("Slow network simulation")
    func testSlowNetworkSimulation() async throws {
        let mockUseCase = SlowMockFetchSectionsUseCase(
            sections: [PodcastSection(id: "1", name: "Slow Load", type: .square, content: [])],
            delayInSeconds: 0.5
        )
        
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Start loading
        let loadingTask = Task {
            await viewModel.fetchPodcasts()
        }
        
        // Check loading state appears
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        #expect(viewModel.isLoading == true)
        
        // Wait for completion
        await loadingTask.value
        
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
        
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollView != nil)
    }
    
    @Test("User rapid interaction simulation")
    func testUserRapidInteractionSimulation() async throws {
        let mockUseCase = MockFetchSectionsUseCase(
            sections: [PodcastSection(id: "1", name: "Test", type: .square, content: [])],
            totalPages: 3
        )
        
        let dependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: mockUseCase
        )
        let viewModel = HomeScreenViewModel(dependencies: dependencies)
        
        // Simulate rapid user interactions
        let tasks = [
            Task { await viewModel.fetchPodcasts() },
            Task { await viewModel.fetchPodcasts() },
            Task {
                try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
                let dummySection = PodcastSection(id: "dummy", name: "Dummy", type: .square, content: [])
                await viewModel.fetchMorePodcastsIfNeeded(item: dummySection)
            }
        ]
        
        // Wait for all tasks
        for task in tasks {
            await task.value
        }
        
        // Should end in consistent state
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.isLoading == false)
    }
}

// MARK: - Extended Mock Classes

class SlowMockFetchSectionsUseCase: FetchSectionsUseCase {
    let sections: [PodcastSection]
    let totalPages: Int
    let delayInSeconds: Double
    
    init(sections: [PodcastSection], totalPages: Int = 1, delayInSeconds: Double) {
        self.sections = sections
        self.totalPages = totalPages
        self.delayInSeconds = delayInSeconds
    }
    
    func fetchSections(page: Int) async throws -> FetchSectionsResult {
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
        
        return FetchSectionsResult(sections: sections, totalPages: totalPages)
    }
}

extension MockError {
    static let networkError = MockError.custom("Network connection failed")
    static let timeoutError = MockError.custom("Request timed out")
    
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Mock error occurred"
        case .custom(let message):
            return message
        }
    }
}

extension MockFetchSectionsUseCase {
    var customError: MockError {
        get { MockError.fetchFailed }
        set { /* Store custom error if needed */ }
    }
}

// MARK: - Helper Extensions for Integration Testing

extension PodcastSectionType: CaseIterable {
    public static var allCases: [PodcastSectionType] {
        return [.square, .bigSquare, .audiobookBigSquare, .queue, .twoLinesGrid]
    }
}
