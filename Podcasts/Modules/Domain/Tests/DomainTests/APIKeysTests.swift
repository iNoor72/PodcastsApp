//
//  APIKeysTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

struct APIKeysTests {
  
  @Test func testAPIKeysConstants() {
      #expect(APIKeys.searchPodcastsBaseURL == "SEARCH_BASE_URL")
      #expect(APIKeys.fetchPodcastsBaseURL == "SECTIONS_BASE_URL")
  }
  
  @Test func testAPIKeysAreNotEmpty() {
      #expect(!APIKeys.searchPodcastsBaseURL.isEmpty)
      #expect(!APIKeys.fetchPodcastsBaseURL.isEmpty)
  }
  
  @Test func testAPIKeysAreUppercase() {
      #expect(APIKeys.searchPodcastsBaseURL == APIKeys.searchPodcastsBaseURL.uppercased())
      #expect(APIKeys.fetchPodcastsBaseURL == APIKeys.fetchPodcastsBaseURL.uppercased())
  }
  
  @Test func testAPIKeysContainExpectedSuffix() {
      #expect(APIKeys.searchPodcastsBaseURL.hasSuffix("BASE_URL"))
      #expect(APIKeys.fetchPodcastsBaseURL.hasSuffix("BASE_URL"))
  }
  
  @Test func testAPIKeysUniqueness() {
      #expect(APIKeys.searchPodcastsBaseURL != APIKeys.fetchPodcastsBaseURL)
  }
}
