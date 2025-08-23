//
//  SearchEndpointTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//


//
//  SearchEndpointTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import Testing
import Foundation
@testable import Domain

struct SearchEndpointTests {
  
  @Test func testSearchEndpoint() {
      let endpoint = SearchEndpoint.search(query: "test query")
      
      #expect(endpoint.path == "/search")
      #expect(endpoint.method == "GET")
      #expect(endpoint.queryItems?.isEmpty == true)
  }
  
  @Test func testSearchEndpointWithEmptyQuery() {
      let endpoint = SearchEndpoint.search(query: "")
      
      #expect(endpoint.path == "/search")
      #expect(endpoint.method == "GET")
  }
  
  @Test func testSearchEndpointWithSpecialCharacters() {
      let specialQuery = "test@#$%^&*()"
      let endpoint = SearchEndpoint.search(query: specialQuery)
      
      #expect(endpoint.path == "/search")
  }
  
  @Test func testSearchEndpointMethod() {
      let endpoint = SearchEndpoint.search(query: "test")
      
      #expect(endpoint.method.uppercased() == "GET")
  }
  
  @Test func testSearchEndpointPath() {
      let endpoint = SearchEndpoint.search(query: "test")
      
      #expect(endpoint.path.hasPrefix("/"))
      #expect(endpoint.path == "/search")
  }
  
  @Test func testSearchEndpointQueryItems() {
      let endpoint = SearchEndpoint.search(query: "test")
      
      #expect(endpoint.queryItems != nil)
      #expect(endpoint.queryItems?.isEmpty == true)
  }
  
  @Test func testSearchEndpointBaseURL() {
      let endpoint = SearchEndpoint.search(query: "test")
      let baseURL = endpoint.base
      
      #expect(!baseURL.isEmpty)
  }
}
