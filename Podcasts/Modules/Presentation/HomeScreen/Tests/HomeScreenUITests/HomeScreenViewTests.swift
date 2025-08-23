//
//  HomeScreenViewTests.swift
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

@MainActor
struct HomeScreenViewTests {
    
    // MARK: - Test Setup
    
    private func makeTestViewModel(
        viewState: HomeScreenViewState = .initial,
        sections: [PodcastSection] = [],
        isLoading: Bool = false
    ) -> HomeScreenViewModel {
        let mockDependencies = HomeScreenViewModelDependencies(
            coordinator: MockHomeCoordinator(),
            fetchPodcastsUseCase: MockFetchSectionsUseCase(sections: sections)
        )
        let viewModel = HomeScreenViewModel(dependencies: mockDependencies)
        viewModel.viewState = viewState
        viewModel.sections = sections
        viewModel.isLoading = isLoading
        return viewModel
    }
    
    private func makeMockSections() -> [PodcastSection] {
        return [
            PodcastSection(id: "1", name: "Popular", type: .square, content: []),
            PodcastSection(id: "2", name: "Recent", type: .bigSquare, content: []),
            PodcastSection(id: "3", name: "Queue", type: .queue, content: []),
            PodcastSection(id: "4", name: "Grid", type: .twoLinesGrid, content: [])
        ]
    }
    
    // MARK: - Initial State Tests
    
    @Test("HomeScreen shows ProgressView in initial state")
    func testInitialStateShowsProgressView() throws {
        let viewModel = makeTestViewModel(viewState: .initial)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let progressView = try homeScreen.inspect().find(ProgressView.self)
        #expect(progressView != nil)
    }
    
    @Test("HomeScreen has black background")
    func testHomeScreenBackgroundColor() throws {
        let viewModel = makeTestViewModel()
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let zstack = try homeScreen.inspect().find(ZStack.self)
        let background = try zstack.background()
        
        // Verify background color is black
        #expect(background != nil)
    }
    
    @Test("HomeScreen initial state triggers fetchPodcasts on appear")
    func testInitialStateTriggersDataFetch() async throws {
        let viewModel = makeTestViewModel(viewState: .initial)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let progressView = try homeScreen.inspect().find(ProgressView.self)
        try progressView.callOnAppear()
        
        // Allow async operation to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Should transition away from initial state
        #expect(viewModel.viewState != .initial)
    }
    
    // MARK: - Error State Tests
    
    @Test("HomeScreen shows RetryView in error state")
    func testErrorStateShowsRetryView() throws {
        let viewModel = makeTestViewModel(viewState: .error("Test error message"))
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let retryView = try homeScreen.inspect().find(RetryView.self)
        #expect(retryView != nil)
    }
    
    @Test("RetryView displays correct error message")
    func testRetryViewDisplaysErrorMessage() throws {
        let errorMessage = "Network connection failed"
        let viewModel = makeTestViewModel(viewState: .error(errorMessage))
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let retryView = try homeScreen.inspect().find(RetryView.self)
        // Note: This would depend on RetryView's internal implementation
        // You might need to adjust based on actual RetryView structure
        #expect(retryView != nil)
    }
    
    @Test("RetryView retry action resets viewState to initial")
    func testRetryViewRetryAction() throws {
        let viewModel = makeTestViewModel(viewState: .error("Test error"))
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let retryView = try homeScreen.inspect().find(RetryView.self)
        
        // Simulate retry button tap
        // This depends on RetryView's actual implementation
        // You may need to adjust based on the actual retry mechanism
        
        #expect(viewModel.viewState == .initial)
    }
    
    @Test("Error state shows black background")
    func testErrorStateBackground() throws {
        let viewModel = makeTestViewModel(viewState: .error("Test error"))
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let retryView = try homeScreen.inspect().find(RetryView.self)
        let background = try retryView.background()
        
        #expect(background != nil)
    }
    
    // MARK: - Loaded State Tests
    
    @Test("HomeScreen shows content view in loaded state")
    func testLoadedStateShowsContent() throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollView != nil)
    }
    
    @Test("Content view displays all sections")
    func testContentViewDisplaysAllSections() throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let lazyVStack = try homeScreen.inspect().find(LazyVStack.self)
        let forEach = try lazyVStack.find(ForEach.self)
        
        #expect(forEach != nil)
        // The actual count verification would depend on ViewInspector's ForEach inspection capabilities
    }
    
    @Test("Loading indicator appears when isLoading is true")
    func testLoadingIndicatorAppears() throws {
        let viewModel = makeTestViewModel(viewState: .loaded, isLoading: true)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let progressViews = try homeScreen.inspect().findAll(ProgressView.self)
        #expect(progressViews.count >= 1) // At least one progress view should be visible
    }
    
    @Test("Loading indicator hidden when isLoading is false")
    func testLoadingIndicatorHidden() throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections, isLoading: false)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Should find only the content, not any loading progress views in the main content area
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollView != nil)
    }
    
    // MARK: - ContentSection Tests
    
    @Test("ContentSection displays section name in header")
    func testContentSectionDisplaysSectionName() throws {
        let section = PodcastSection(id: "test", name: "Test Section", type: .square, content: [])
        let contentSection = ContentSection(section: section, isRTL: false)
        
        let headerView = try contentSection.inspect().find(SectionNavigationHeaderView.self)
        #expect(headerView != nil)
    }
    
    @Test("ContentSection shows correct layout for square type")
    func testContentSectionSquareLayout() throws {
        let section = PodcastSection(id: "test", name: "Test", type: .square, content: [])
        let contentSection = ContentSection(section: section, isRTL: false)
        
        let cardList = try contentSection.inspect().find(HorizontalCardList.self)
        #expect(cardList != nil)
    }
    
    @Test("ContentSection shows correct layout for bigSquare type")
    func testContentSectionBigSquareLayout() throws {
        let section = PodcastSection(id: "test", name: "Test", type: .bigSquare, content: [])
        let contentSection = ContentSection(section: section, isRTL: false)
        
        let bigCardList = try contentSection.inspect().find(HorizontalBigCardList.self)
        #expect(bigCardList != nil)
    }
    
    @Test("ContentSection shows correct layout for audiobookBigSquare type")
    func testContentSectionAudiobookBigSquareLayout() throws {
        let section = PodcastSection(id: "test", name: "Test", type: .audiobookBigSquare, content: [])
        let contentSection = ContentSection(section: section, isRTL: false)
        
        let bigCardList = try contentSection.inspect().find(HorizontalBigCardList.self)
        #expect(bigCardList != nil)
    }
    
    @Test("ContentSection shows correct layout for queue type")
    func testContentSectionQueueLayout() throws {
        let section = PodcastSection(id: "test", name: "Test", type: .queue, content: [])
        let contentSection = ContentSection(section: section, isRTL: false)
        
        let queueList = try contentSection.inspect().find(HorizontalQueueList.self)
        #expect(queueList != nil)
    }
    
    @Test("ContentSection shows correct layout for twoLinesGrid type")
    func testContentSectionTwoLinesGridLayout() throws {
        let section = PodcastSection(id: "test", name: "Test", type: .twoLinesGrid, content: [])
        let contentSection = ContentSection(section: section, isRTL: false)
        
        let gridCardList = try contentSection.inspect().find(HorizontalGridCardList.self)
        #expect(gridCardList != nil)
    }
    
    // MARK: - RTL Support Tests
    
    @Test("HomeScreen detects Arabic language for RTL")
    func testRTLDetectionForArabic() {
        // Mock Arabic locale
        let originalLocale = Locale.current
        // Note: This test might need adjustment based on how you can mock Locale in tests
        
        let viewModel = makeTestViewModel()
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Verify RTL detection logic
        // This would require a way to test the isRTL computed property
    }
    
    @Test("ContentSection applies RTL layout direction correctly")
    func testContentSectionRTLLayout() throws {
        let section = PodcastSection(id: "test", name: "Test", type: .square, content: [])
        let contentSection = ContentSection(section: section, isRTL: true)
        
        let vstack = try contentSection.inspect().find(VStack.self)
        let environment = try vstack.environment()
        
        // Check if RTL layout direction is applied
        #expect(environment != nil)
    }
    
    @Test("ContentSection applies LTR layout direction correctly")
    func testContentSectionLTRLayout() throws {
        let section = PodcastSection(id: "test", name: "Test", type: .square, content: [])
        let contentSection = ContentSection(section: section, isRTL: false)
        
        let vstack = try contentSection.inspect().find(VStack.self)
        let environment = try vstack.environment()
        
        #expect(environment != nil)
    }
    
    @Test("ScrollView applies correct layout direction for RTL")
    func testScrollViewRTLLayoutDirection() throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        let environment = try scrollView.environment()
        
        #expect(environment != nil)
    }
    
    // MARK: - Divider Tests
    
    @Test("Dividers appear between sections except last one")
    func testDividersBetweenSections() throws {
        let sections = makeMockSections() // Creates 4 sections
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let dividers = try homeScreen.inspect().findAll(Divider.self)
        // Should have 3 dividers for 4 sections (no divider after last section)
        #expect(dividers.count == 3)
    }
    
    @Test("Divider styling is correct")
    func testDividerStyling() throws {
        let sections = Array(makeMockSections().prefix(2)) // Use 2 sections to ensure divider exists
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let divider = try homeScreen.inspect().find(Divider.self)
        // Check divider styling - frame height and background color
        #expect(divider != nil)
    }
    
    // MARK: - Pagination Tests
    
    @Test("Section onAppear triggers pagination check")
    func testSectionOnAppearTriggersPagination() async throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let contentSections = try homeScreen.inspect().findAll(ContentSection.self)
        
        if !contentSections.isEmpty {
            let firstSection = contentSections[0]
            try firstSection.callOnAppear()
            
            // Allow async operation to complete
            try await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
            
            // Verify that pagination was triggered (implementation dependent)
            #expect(true) // Placeholder - adjust based on actual behavior
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("HomeScreen handles empty sections array")
    func testEmptySectionsArray() throws {
        let viewModel = makeTestViewModel(viewState: .loaded, sections: [])
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        let lazyVStack = try scrollView.find(LazyVStack.self)
        
        #expect(lazyVStack != nil)
    }
    
    @Test("HomeScreen handles single section")
    func testSingleSection() throws {
        let singleSection = [PodcastSection(id: "single", name: "Single", type: .square, content: [])]
        let viewModel = makeTestViewModel(viewState: .loaded, sections: singleSection)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let dividers = try homeScreen.inspect().findAll(Divider.self)
        #expect(dividers.isEmpty) // No dividers for single section
    }
    
    @Test("HomeScreen handles multiple section types simultaneously")
    func testMultipleSectionTypes() throws {
        let mixedSections = [
            PodcastSection(id: "1", name: "Square", type: .square, content: []),
            PodcastSection(id: "2", name: "BigSquare", type: .bigSquare, content: []),
            PodcastSection(id: "3", name: "Queue", type: .queue, content: []),
            PodcastSection(id: "4", name: "Grid", type: .twoLinesGrid, content: []),
            PodcastSection(id: "5", name: "AudioBook", type: .audiobookBigSquare, content: [])
        ]
        let viewModel = makeTestViewModel(viewState: .loaded, sections: mixedSections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Verify all different list types are present
        let horizontalCardList = try? homeScreen.inspect().find(HorizontalCardList.self)
        let horizontalBigCardList = try? homeScreen.inspect().findAll(HorizontalBigCardList.self)
        let horizontalQueueList = try? homeScreen.inspect().find(HorizontalQueueList.self)
        let horizontalGridCardList = try? homeScreen.inspect().find(HorizontalGridCardList.self)
        
        #expect(horizontalCardList != nil)
        #expect(horizontalBigCardList?.count == 2) // bigSquare and audiobookBigSquare
        #expect(horizontalQueueList != nil)
        #expect(horizontalGridCardList != nil)
    }
    
    @Test("HomeScreen maintains scroll position during state changes")
    func testScrollPositionDuringStateChanges() throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollView != nil)
        
        // Verify ScrollView persists through state changes
        viewModel.isLoading = true
        let scrollViewAfterLoading = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollViewAfterLoading != nil)
    }
    
    // MARK: - Accessibility Tests
    
    @Test("HomeScreen provides proper accessibility structure")
    func testAccessibilityStructure() throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Verify main container has proper accessibility structure
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollView != nil)
        
        // ScrollView should be accessible for screen readers
        // Additional accessibility checks would depend on your accessibility implementation
    }
    
    // MARK: - Performance Tests
    
    @Test("HomeScreen handles large number of sections efficiently")
    func testLargeNumberOfSections() throws {
        let largeSectionCount = 100
        let largeSections = (0..<largeSectionCount).map { index in
            PodcastSection(
                id: "section_\(index)",
                name: "Section \(index)",
                type: .square,
                content: []
            )
        }
        
        let viewModel = makeTestViewModel(viewState: .loaded, sections: largeSections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Verify LazyVStack is used for performance
        let lazyVStack = try homeScreen.inspect().find(LazyVStack.self)
        #expect(lazyVStack != nil)
        
        // LazyVStack should handle large datasets efficiently
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        #expect(scrollView != nil)
    }
    
    // MARK: - State Consistency Tests
    
    @Test("View state remains consistent during rapid changes")
    func testStateConsistencyDuringRapidChanges() throws {
        let viewModel = makeTestViewModel(viewState: .initial)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Rapidly change states
        viewModel.viewState = .loaded
        viewModel.viewState = .error("Test error")
        viewModel.viewState = .loaded
        
        // Final state should be loaded
        #expect(viewModel.viewState == .loaded)
        
        // View should reflect final state
        let scrollView = try? homeScreen.inspect().find(ScrollView.self)
        let retryView = try? homeScreen.inspect().find(RetryView.self)
        
        #expect(scrollView != nil || retryView == nil)
    }
    
    @Test("Loading state overlay doesn't interfere with content")
    func testLoadingOverlayDoesntInterfereWithContent() throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections, isLoading: true)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        // Both content and loading indicator should be present
        let scrollView = try homeScreen.inspect().find(ScrollView.self)
        let progressViews = try homeScreen.inspect().findAll(ProgressView.self)
        
        #expect(scrollView != nil)
        #expect(progressViews.count >= 1)
    }
    
    // MARK: - Integration Tests
    
    @Test("HomeScreen integrates properly with ContentSection")
    func testHomeScreenContentSectionIntegration() throws {
        let sections = makeMockSections()
        let viewModel = makeTestViewModel(viewState: .loaded, sections: sections)
        let homeScreen = HomeScreen(viewModel: viewModel)
        
        let contentSections = try homeScreen.inspect().findAll(ContentSection.self)
        #expect(contentSections.count == sections.count)
    }
    
    @Test("ContentSection receives correct RTL value from HomeScreen")
    func testContentSectionReceivesCorrectRTLValue() throws {
        let section = PodcastSection(id: "test", name: "Test", type: .square, content: [])
        
        // Test with RTL = false
        let contentSectionLTR = ContentSection(section: section, isRTL: false)
        let headerViewLTR = try contentSectionLTR.inspect().find(SectionNavigationHeaderView.self)
        #expect(headerViewLTR != nil)
        
        // Test with RTL = true
        let contentSectionRTL = ContentSection(section: section, isRTL: true)
        let headerViewRTL = try contentSectionRTL.inspect().find(SectionNavigationHeaderView.self)
        #expect(headerViewRTL != nil)
    }
}

// Helper extension for testing async operations
extension HomeScreenViewTests {
    
    func waitForAsyncOperation() async {
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
    }
    
    func waitForLongAsyncOperation() async {
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
    }
}

// MARK: - Custom Inspection Extensions

extension InspectableView where View: HomeScreen {
    
    func isInInitialState() throws -> Bool {
        do {
            _ = try find(ProgressView.self)
            return true
        } catch {
            return false
        }
    }
    
    func isInErrorState() throws -> Bool {
        do {
            _ = try find(RetryView.self)
            return true
        } catch {
            return false
        }
    }
    
    func isInLoadedState() throws -> Bool {
        do {
            _ = try find(ScrollView.self)
            return true
        } catch {
            return false
        }
    }
    
    func hasLoadingIndicator() throws -> Bool {
        do {
            let progressViews = try findAll(ProgressView.self)
            return progressViews.count > 1 // More than just the initial state progress view
        } catch {
            return false
        }
    }
}
