//
//  PodcastSectionTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

struct PodcastSectionTests {
  
  @Test func testPodcastSectionInitialization() {
      let content = [createMockPodcastContent()]
      let section = PodcastSection(
          name: "Test Section",
          type: .square,
          contentType: "podcast",
          order: 1,
          content: content
      )
      
      #expect(section.name == "Test Section")
      #expect(section.type == .square)
      #expect(section.contentType == "podcast")
      #expect(section.order == 1)
      #expect(section.content.count == 1)
  }
  
  @Test func testPodcastSectionEquality() {
      let content = [createMockPodcastContent()]
      let section1 = PodcastSection(
          name: "Test Section",
          type: .square,
          contentType: "podcast",
          order: 1,
          content: content
      )
      
      let section2 = PodcastSection(
          name: "Test Section",
          type: .square,
          contentType: "podcast",
          order: 1,
          content: content
      )
      
      #expect(section1 != section2)
  }
  
  @Test func testPodcastSectionHashable() {
      let content = [createMockPodcastContent()]
      let section = PodcastSection(
          name: "Test Section",
          type: .square,
          contentType: "podcast",
          order: 1,
          content: content
      )
      
      let set: Set<PodcastSection> = [section]
      #expect(set.count == 1)
  }
  
  private func createMockPodcastContent() -> PodcastContent {
      return PodcastContent(
          podcastID: "123",
          name: "Test Podcast",
          description: "Test Description",
          avatarURL: "https://example.com/avatar.jpg",
          episodeCount: 10,
          duration: 3600,
          priority: 1,
          popularityScore: 100,
          score: 4.5,
          language: "en",
          podcastPopularityScore: 90,
          podcastPriority: 1,
          episodeID: "ep123",
          seasonNumber: 1,
          episodeType: nil,
          podcastName: "Test Podcast",
          authorName: "Test Author",
          number: 1,
          separatedAudioURL: nil,
          audioURL: "https://example.com/audio.mp3",
          releaseDate: "2024-01-01",
          chapters: nil,
          paidIsEarlyAccess: false,
          paidIsNowEarlyAccess: false,
          paidIsExclusive: false,
          paidTranscriptURL: nil,
          freeTranscriptURL: nil,
          paidIsExclusivePartially: false,
          paidExclusiveStartTime: nil,
          paidEarlyAccessDate: nil,
          paidEarlyAccessAudioURL: nil,
          paidExclusivityType: nil,
          audiobookID: nil,
          articleID: nil
      )
  }
}
