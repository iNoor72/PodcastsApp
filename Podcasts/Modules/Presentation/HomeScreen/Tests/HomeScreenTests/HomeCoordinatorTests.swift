//
//  HomeCoordinatorTests.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 24/08/2025.
//

import Testing
import SwiftUI
@testable import HomeScreen
@testable import Common

@Suite("HomeCoordinator Tests")
struct HomeCoordinatorTests {
    
    @Test("HomeCoordinator initializes with empty path and no modal by default")
    func testInitialization_DefaultValues() {
        let coordinator = HomeCoordinator(path: [])
        
        #expect(coordinator.path.isEmpty)
        #expect(coordinator.modal == nil)
        #expect(coordinator.rootCoordinator == nil)
    }
    
    @Test("HomeCoordinator initializes with provided path")
    func testInitialization_WithPath() {
        let initialPath: [HomeCoordinator.Route] = [.search]
        let coordinator = HomeCoordinator(path: initialPath)
        
        #expect(coordinator.path == initialPath)
        #expect(coordinator.modal == nil)
    }
    
    @Test("HomeCoordinator initializes with path and modal")
    func testInitialization_WithPathAndModal() {
        let initialPath: [HomeCoordinator.Route] = [.search]
        let modal = ModalRoute<HomeCoordinator.Route>.sheet(.search)
        let coordinator = HomeCoordinator(path: initialPath, modal: modal)
        
        #expect(coordinator.path == initialPath)
        #expect(coordinator.modal == modal)
    }
    
    @Test("Route enum conforms to Hashable")
    func testRouteHashable() {
        let route1 = HomeCoordinator.Route.search
        let route2 = HomeCoordinator.Route.search
        
        #expect(route1 == route2)
        #expect(route1.hashValue == route2.hashValue)
    }
    
    @Test("routeToSearchScreen appends search route to path")
    func testRouteToSearchScreen_AppendsToPath() {
        let coordinator = HomeCoordinator(path: [])
        
        coordinator.routeToSearchScreen()
        
        #expect(coordinator.path == [.search])
    }
    
    @Test("routeToSearchScreen appends to existing path")
    func testRouteToSearchScreen_AppendsToExistingPath() {
        let coordinator = HomeCoordinator(path: [.search])
        
        coordinator.routeToSearchScreen()
        
        #expect(coordinator.path == [.search, .search])
    }
    
    @Test("Multiple navigation calls append multiple routes")
    func testMultipleNavigationCalls() {
        let coordinator = HomeCoordinator(path: [])
        
        coordinator.routeToSearchScreen()
        coordinator.routeToSearchScreen()
        coordinator.routeToSearchScreen()
        
        #expect(coordinator.path == [.search, .search, .search])
    }
    
    @Test("view(for:) returns ProgressView for search route")
    func testViewForRoute_Search() {
        let coordinator = HomeCoordinator(path: [])
        
        let view = coordinator.view(for: .search)
        
        // Since we can't directly test the view content in Swift Testing,
        // we verify that the method doesn't crash and returns a view
        #expect(view is ProgressView<ProgressViewStyleConfiguration.Content>)
    }
    
    @Test("HomeCoordinator conforms to HomeCoordinatorProtocol")
    func testProtocolConformance() {
        let coordinator = HomeCoordinator(path: [])
        let protocolInstance: HomeCoordinatorProtocol = coordinator
        
        protocolInstance.routeToSearchScreen()
        
        #expect(coordinator.path == [.search])
    }
    
    @Test("HomeCoordinator conforms to RoutableCoordinator")
    func testRoutableCoordinatorConformance() {
        let coordinator = HomeCoordinator(path: [])
        let routableCoordinator: RoutableCoordinator = coordinator
        
        #expect(routableCoordinator.path.isEmpty)
        #expect(routableCoordinator.modal == nil)
        #expect(routableCoordinator.rootCoordinator == nil)
    }
    
    @Test("rootCoordinator can be set and retrieved")
    func testRootCoordinatorProperty() {
        let coordinator = HomeCoordinator(path: [])
        let rootCoordinator = HomeCoordinator(path: [])
        
        coordinator.rootCoordinator = rootCoordinator
        
        #expect(coordinator.rootCoordinator === rootCoordinator)
    }
    
    @Test("rootCoordinator is weak reference")
    func testRootCoordinatorWeakReference() {
        let coordinator = HomeCoordinator(path: [])
        
        // Create a root coordinator in a scope that will be deallocated
        do {
            let rootCoordinator = HomeCoordinator(path: [])
            coordinator.rootCoordinator = rootCoordinator
            #expect(coordinator.rootCoordinator === rootCoordinator)
        }
        
        // After the scope, rootCoordinator should be nil (weak reference)
        // Note: This test might be flaky due to ARC timing
        #expect(coordinator.rootCoordinator == nil)
    }
    
    // MARK: - Path Manipulation Tests
    
    @Test("Path can be modified directly")
    func testPathDirectModification() {
        let coordinator = HomeCoordinator(path: [])
        
        coordinator.path = [.search]
        #expect(coordinator.path == [.search])
        
        coordinator.path.append(.search)
        #expect(coordinator.path == [.search, .search])
        
        coordinator.path.removeAll()
        #expect(coordinator.path.isEmpty)
    }
    
    @Test("Modal can be set and cleared")
    func testModalProperty() {
        let coordinator = HomeCoordinator(path: [])
        
        #expect(coordinator.modal == nil)
        
        let modal = ModalRoute<HomeCoordinator.Route>.sheet(.search)
        coordinator.modal = modal
        
        #expect(coordinator.modal == modal)
        
        coordinator.modal = nil
        #expect(coordinator.modal == nil)
    }

    @Test("Empty path remains empty after initialization")
    func testEmptyPathEdgeCase() {
        let coordinator = HomeCoordinator(path: [])
        
        #expect(coordinator.path.isEmpty)
        #expect(coordinator.path.count == 0)
    }
    
    @Test("Large path can be handled")
    func testLargePathHandling() {
        let largePath = Array(repeating: HomeCoordinator.Route.search, count: 1000)
        let coordinator = HomeCoordinator(path: largePath)
        
        #expect(coordinator.path.count == 1000)
        #expect(coordinator.path.allSatisfy { $0 == .search })
    }
}
