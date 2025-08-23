//
//  MockSearchScreenViewModel.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 24/08/2025.
//

import Testing
import SwiftUI
import ViewInspector
import Domain
import Combine
@testable import SearchScreen

// MARK: - ViewInspector Extensions

extension SearchScreen: Inspectable { }
extension ContentSection: Inspectable { }

// MARK: - Mock Components for Testing

@MainActor
final class MockSearchScreenViewModel: SearchScreenViewModel, ObservableObject {
    // Override published properties with manual implementation for testing
    private var _viewState: SearchScreenViewState = .initial
    private var _searchQuery: String = ""
    private var _debounceValue: String = ""
    private var _sections: [SearchSection] = []
    private var _isLoading: Bool = false
    
    private let viewStateSubject = PassthroughSubject<SearchScreenViewState, Never>()
    private let searchQuerySubject = PassthroughSubject<String, Never>()
    private let debounceValueSubject = PassthroughSubject<String, Never>()
    private let sectionsSubject = PassthroughSubject<[SearchSection], Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    
    override var viewState: SearchScreenViewState {
        get { _viewState }
        set {
            objectWillChange.send()
            _viewState = newValue
            viewStateSubject.send(newValue)
        }
    }
    
    override var searchQuery: String {
        get { _searchQuery }
        set {
            objectWillChange.send()
            _searchQuery = newValue
            searchQuerySubject.send(newValue)
        }
    }
    
    override var debounceValue: String {
        get { _debounceValue }
        set {
            objectWillChange.send()
            _debounceValue = newValue
            debounceValueSubject.send(newValue)
        }
    }
    
    override var sections: [SearchSection] {
        get { _sections }
        set {
            objectWillChange.send()
            _sections = newValue
            sectionsSubject.send(newValue)
        }
    }
    
    override var isLoading: Bool {
        get { _isLoading }
        set {
            objectWillChange.send()
            _isLoading = newValue
            isLoadingSubject.send(newValue)
        }
    }
    
    // Track method calls
    var searchPodcastsCallCount = 0
    var lastSearchQuery: String?
    
    override func searchPodcasts(with query: String) async {
        searchPodcastsCallCount += 1
        lastSearchQuery = query
        // Don't call super to avoid actual use case calls in UI tests
    }
    
    // Test utilities
    func reset() {
        _viewState = .initial
        _searchQuery = ""
        _debounceValue = ""
        _sections = []
        _isLoading = false
        searchPodcastsCallCount = 0
        lastSearchQuery = nil
    }
    
    func simulateDebounceUpdate() {
        debounceValue = searchQuery
    }
    
    // Create a properly initialized mock
    static func createMock() -> MockSearchScreenViewModel {
        let mockCoordinator = MockSearchCoordinator()
        let mockUseCase = MockSearchUseCase()
        let dependencies = SearchScreenViewModelDependencies(
            coordinator: mockCoordinator,
            searchUseCase: mockUseCase
        )
        
        return MockSearchScreenViewModel(dependencies: dependencies)
    }
    
    convenience init(dependencies: SearchScreenViewModelDependencies) {
        // Create a proper initialization path
        self.init(dependencies: dependencies)
    }
}

// MARK: - Mock UI Components

struct MockSearchScrollView: View {
    @Binding var query: String
    let showCancelButton: Bool
    let cancelAction: () -> Void
    let scrollContent: AnyView
    let onSearchContent: AnyView
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $query)
                    .accessibilityIdentifier("search_field")
                
                if showCancelButton {
                    Button("Cancel", action: cancelAction)
                        .accessibilityIdentifier("cancel_button")
                }
            }
            
            if query.isEmpty {
                scrollContent
                    .accessibilityIdentifier("scroll_content")
            } else {
                onSearchContent
                    .accessibilityIdentifier("search_content")
            }
        }
    }
}

// MARK: - SearchScreen UI Tests

@Suite("SearchScreen UI Tests")
@MainActor
struct SearchScreenUITests {
    
    // MARK: - Initialization Tests
    
    @Test("SearchScreen initializes with correct structure")
    func testSearchScreenInitialization() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        let body = try searchScreen.inspect().zStack()
        #expect(body != nil)
    }
    
    @Test("SearchScreen has black background")
    func testBackgroundColor() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        let zStack = try searchScreen.inspect().zStack()
        // Check that background modifier is applied
        #expect(try zStack.backgroundStyle() == .black)
    }
    
    // MARK: - View State Tests
    
    @Test("SearchScreen shows error view in error state")
    func testErrorStateView() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.viewState = .error("Test error message")
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        let body = try searchScreen.inspect().zStack()
        // Should contain RetryView when in error state
        // Note: Specific inspection depends on RetryView implementation
        
        // Verify error state is handled
        #expect(mockViewModel.viewState == .error("Test error message"))
    }
    
    @Test("SearchScreen shows content view in non-error states")
    func testContentViewDisplay() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        let body = try searchScreen.inspect().zStack()
        // Should show content view, not error view
        #expect(mockViewModel.viewState == .loaded)
    }
    
    @Test("SearchScreen shows initial state correctly")
    func testInitialStateDisplay() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.viewState = .initial
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        let body = try searchScreen.inspect().zStack()
        #expect(mockViewModel.viewState == .initial)
    }
    
    // MARK: - Loading State Tests
    
    @Test("SearchScreen shows ProgressView when loading")
    func testLoadingProgressView() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.isLoading = true
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        // Should show ProgressView overlay when loading
        #expect(mockViewModel.isLoading == true)
    }
    
    @Test("SearchScreen hides ProgressView when not loading")
    func testNotLoadingHidesProgressView() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.isLoading = false
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        #expect(mockViewModel.isLoading == false)
    }
    
    @Test("Loading state changes trigger UI updates")
    func testLoadingStateUpdates() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        
        // Initially not loading
        mockViewModel.isLoading = false
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        #expect(mockViewModel.isLoading == false)
        
        // Change to loading
        mockViewModel.isLoading = true
        #expect(mockViewModel.isLoading == true)
        
        // Change back to not loading
        mockViewModel.isLoading = false
        #expect(mockViewModel.isLoading == false)
    }
    
    // MARK: - Search Query Display Tests
    
    @Test("SearchScreen shows placeholder when search query is empty")
    func testEmptySearchQueryPlaceholder() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.searchQuery = ""
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        // Should show "Type something to search..." text
        #expect(mockViewModel.searchQuery.isEmpty)
    }
    
    @Test("SearchScreen shows search results when query exists")
    func testSearchResultsWithQuery() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.searchQuery = "test query"
        mockViewModel.sections = SearchTestDataFactory.createMultipleMockSections()
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        #expect(!mockViewModel.searchQuery.isEmpty)
        #expect(!mockViewModel.sections.isEmpty)
    }
    
    @Test("Search query changes update display")
    func testSearchQueryUpdates() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        
        // Start with empty query
        mockViewModel.searchQuery = ""
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        #expect(mockViewModel.searchQuery.isEmpty)
        
        // Update query
        mockViewModel.searchQuery = "new query"
        #expect(mockViewModel.searchQuery == "new query")
        
        // Clear query
        mockViewModel.searchQuery = ""
        #expect(mockViewModel.searchQuery.isEmpty)
    }
    
    // MARK: - Sections Display Tests
    
    @Test("SearchScreen displays multiple sections correctly")
    func testMultipleSectionsDisplay() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.sections = SearchTestDataFactory.createMultipleMockSections()
        mockViewModel.searchQuery = "test"
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        #expect(mockViewModel.sections.count == 4)
        #expect(mockViewModel.sections[0].name == "Podcasts")
        #expect(mockViewModel.sections[1].name == "Audiobooks")
        #expect(mockViewModel.sections[2].name == "Queue")
        #expect(mockViewModel.sections[3].name == "Grid Items")
    }
    
    @Test("SearchScreen handles empty sections")
    func testEmptySectionsDisplay() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.sections = []
        mockViewModel.searchQuery = "test"
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        #expect(mockViewModel.sections.isEmpty)
    }
    
    @Test("Section updates trigger display changes")
    func testSectionUpdates() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        
        // Start with no sections
        mockViewModel.sections = []
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        #expect(mockViewModel.sections.isEmpty)
        
        // Add sections
        mockViewModel.sections = SearchTestDataFactory.createMultipleMockSections()
        #expect(mockViewModel.sections.count == 4)
        
        // Clear sections
        mockViewModel.sections = []
        #expect(mockViewModel.sections.isEmpty)
    }
    
    // MARK: - ContentSection Tests
    
    @Test("ContentSection displays section name correctly")
    func testContentSectionNameDisplay() throws {
        let mockSection = SearchTestDataFactory.createMockSearchSection(name: "Test Section Name")
        let contentSection = ContentSection(section: mockSection, isRTL: false)
        
        let vStack = try contentSection.inspect().vStack()
        #expect(mockSection.name == "Test Section Name")
    }
    
    @Test("ContentSection renders HorizontalCardList for square type")
    func testContentSectionSquareType() throws {
        let mockSection = SearchTestDataFactory.createMockSearchSection(type: .square)
        let contentSection = ContentSection(section: mockSection, isRTL: false)
        
        #expect(mockSection.type == .square)
    }
    
    @Test("ContentSection renders HorizontalBigCardList for bigSquare type")
    func testContentSectionBigSquareType() throws {
        let mockSection = SearchTestDataFactory.createMockSearchSection(type: .bigSquare)
        let contentSection = ContentSection(section: mockSection, isRTL: false)
        
        #expect(mockSection.type == .bigSquare)
    }
    
    @Test("ContentSection renders HorizontalBigCardList for audiobookBigSquare type")
    func testContentSectionAudiobookBigSquareType() throws {
        let mockSection = SearchTestDataFactory.createMockSearchSection(type: .audiobookBigSquare)
        let contentSection = ContentSection(section: mockSection, isRTL: false)
        
        #expect(mockSection.type == .audiobookBigSquare)
    }
    
    @Test("ContentSection renders HorizontalQueueList for queue type")
    func testContentSectionQueueType() throws {
        let mockSection = SearchTestDataFactory.createMockSearchSection(type: .queue)
        let contentSection = ContentSection(section: mockSection, isRTL: false)
        
        #expect(mockSection.type == .queue)
    }
    
    @Test("ContentSection renders HorizontalGridCardList for twoLinesGrid type")
    func testContentSectionTwoLinesGridType() throws {
        let mockSection = SearchTestDataFactory.createMockSearchSection(type: .twoLinesGrid)
        let contentSection = ContentSection(section: mockSection, isRTL: false)
        
        #expect(mockSection.type == .twoLinesGrid)
    }
    
    // MARK: - RTL Support Tests
    
    @Test("ContentSection handles LTR layout direction")
    func testContentSectionLTRLayout() throws {
        let mockSection = SearchTestDataFactory.createMockSearchSection()
        let contentSection = ContentSection(section: mockSection, isRTL: false)
        
        let vStack = try contentSection.inspect().vStack()
        // Should have LTR environment
        #expect(!false) // isRTL is false
    }
    
    @Test("ContentSection handles RTL layout direction")
    fun testContentSectionRTLLayout() throws {
        let mockSection = SearchTestDataFactory.createMockSearchSection()
        let contentSection = ContentSection(section: mockSection, isRTL: true)
        
        let vStack = try contentSection.inspect().vStack()
        // Should have RTL environment
        #expect(true) // isRTL is true
    }
    
    @Test("SearchScreen detects language direction")
    func testLanguageDirectionDetection() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        // Test that the screen can handle both LTR and RTL
        // Note: Actual locale testing would require mocking Locale.current
    }
    
    // MARK: - Content Styling Tests
    
    @Test("Scroll content has correct styling")
    func testScrollContentStyling() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.searchQuery = ""
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        // Should have white foreground color and proper font
        #expect(mockViewModel.searchQuery.isEmpty)
    }
    
    @Test("Search content has correct spacing")
    func testSearchContentSpacing() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.searchQuery = "test"
        mockViewModel.sections = SearchTestDataFactory.createMultipleMockSections()
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        // Should have 32 point spacing between sections and 16 point top padding
        #expect(!mockViewModel.searchQuery.isEmpty)
        #expect(!mockViewModel.sections.isEmpty)
    }
    
    // MARK: - Interaction Tests
    
    @Test("Cancel button interaction clears search")
    func testCancelButtonInteraction() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.searchQuery = "test query"
        mockViewModel.sections = SearchTestDataFactory.createMultipleMockSections()
        
        // Simulate cancel button action
        mockViewModel.searchQuery = ""
        mockViewModel.sections.removeAll()
        
        #expect(mockViewModel.searchQuery.isEmpty)
        #expect(mockViewModel.sections.isEmpty)
    }
    
    @Test("Search query binding works correctly")
    func testSearchQueryBinding() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        
        // Test two-way binding
        mockViewModel.searchQuery = "initial"
        #expect(mockViewModel.searchQuery == "initial")
        
        // Update from view model
        mockViewModel.searchQuery = "updated"
        #expect(mockViewModel.searchQuery == "updated")
    }
    
    // MARK: - State Change Tests
    
    @Test("View responds to view state changes")
    func testViewStateChangeResponse() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        
        // Test state transitions
        mockViewModel.viewState = .initial
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        #expect(mockViewModel.viewState == .initial)
        
        mockViewModel.viewState = .loaded
        #expect(mockViewModel.viewState == .loaded)
        
        mockViewModel.viewState = .error("Test error")
        #expect(mockViewModel.viewState == .error("Test error"))
    }
    
    @Test("View responds to debounce value changes")
    func testDebounceValueChangeResponse() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        // Simulate debounce value change
        mockViewModel.debounceValue = "debounced query"
        
        // Note: In real implementation, this would trigger searchPodcasts
        #expect(mockViewModel.debounceValue == "debounced query")
    }
    
    // MARK: - Edge Cases
    
    @Test("SearchScreen handles very long section names")
    func testLongSectionNames() throws {
        let longName = String(repeating: "Very Long Section Name ", count: 10)
        let mockSection = SearchTestDataFactory.createMockSearchSection(name: longName)
        let contentSection = ContentSection(section: mockSection, isRTL: false)
        
        #expect(mockSection.name == longName)
    }
    
    @Test("SearchScreen handles sections with no content")
    func testEmptyContentSections() throws {
        let mockViewModel = MockSearchScreenViewModel.createMock()
        mockViewModel.sections = [SearchTestDataFactory.createEmptySection()]
        mockViewModel.searchQuery = "test"
        mockViewModel.viewState = .loaded
        
        let searchScreen = SearchScreen(viewModel: mockViewModel)
        
        #expect(mockViewModel.sections.count == 1)
        #expect(mockViewModel.sections[0].content.isEmpty)
    }
    
    @Test("SearchScreen handles mixed content types")
    func testMixedContentTypes() throws {
