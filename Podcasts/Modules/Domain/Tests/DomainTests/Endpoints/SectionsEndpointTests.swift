//
//  SectionsEndpointTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

struct SectionsEndpointTests {
  
  @Test func testFetchSectionsEndpoint() {
      let endpoint = SectionsEnpoint.fetchSections(page: 1)
      
      #expect(endpoint.base == "https://api-v2-b2sit6oh3a-uc.a.run.app")
      #expect(endpoint.path == "/home_sections")
      #expect(endpoint.method == "GET")
      #expect(endpoint.queryItems?["page"] == "1")
  }
  
  @Test func testFetchSectionsWithDifferentPages() {
      let page5Endpoint = SectionsEnpoint.fetchSections(page: 5)
      let page100Endpoint = SectionsEnpoint.fetchSections(page: 100)
      
      #expect(page5Endpoint.queryItems?["page"] == "5")
      #expect(page100Endpoint.queryItems?["page"] == "100")
  }
  
  @Test func testFetchSectionsWithZeroPage() {
      let endpoint = SectionsEnpoint.fetchSections(page: 0)
      
      #expect(endpoint.queryItems?["page"] == "0")
  }
  
  @Test func testFetchSectionsWithNegativePage() {
      let endpoint = SectionsEnpoint.fetchSections(page: -1)
      
      #expect(endpoint.queryItems?["page"] == "-1")
  }
  
  @Test func testFetchSectionsBaseURL() {
      let endpoint = SectionsEnpoint.fetchSections(page: 1)
      
      #expect(endpoint.base.hasPrefix("https://"))
      #expect(!endpoint.base.isEmpty)
  }
  
  @Test func testFetchSectionsPath() {
      let endpoint = SectionsEnpoint.fetchSections(page: 1)
      
      #expect(endpoint.path.hasPrefix("/"))
      #expect(endpoint.path == "/home_sections")
  }
  
  @Test func testFetchSectionsMethod() {
      let endpoint = SectionsEnpoint.fetchSections(page: 1)
      
      #expect(endpoint.method.uppercased() == "GET")
  }
  
  @Test func testFetchSectionsQueryItemsNotEmpty() {
      let endpoint = SectionsEnpoint.fetchSections(page: 42)
      
      #expect(endpoint.queryItems != nil)
      #expect(endpoint.queryItems?.isEmpty == false)
  }
}
