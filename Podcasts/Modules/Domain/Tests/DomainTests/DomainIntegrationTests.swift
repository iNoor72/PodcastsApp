//
//  DomainIntegrationTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

struct DomainIntegrationTests {
  
  @Test func testPodcastSectionWithChapters() {
      let chapters = [
          PodcastChapter(title: "Introduction"),
          PodcastChapter(title: "Main Content"),
          PodcastChapter(title: "Conclusion")
      ]
      
      let content = PodcastContent(
          podcastID: "123",
          name: "Test Episode",
          description: "Test Description",
          avatarURL: "https://example.com/avatar.jpg",
          episodeCount: 1,
          duration: 3600,
          priority: 1,
          popularityScore: 100,
          score: 4.5,
          language: "en",
          podcastPopularityScore: 90,
          podcastPriority: 1,
          episodeID: "ep123",
          seasonNumber: 1,
          episodeType: .full,
          podcastName: "Test Podcast",
          authorName: "Test Author",
          number: 1,
          separatedAudioURL: nil,
          audioURL: "https://example.com/audio.mp3",
          releaseDate: "2024-01-01",
          chapters: chapters,
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
      
      let section = PodcastSection(
          name: "Featured Episodes",
          type: .bigSquare,
          contentType: "episode",
          order: 1,
          content: [content]
      )
      
      #expect(section.content.first?.chapters?.count == 3)
      #expect(section.content.first?.episodeType == .full)
      #expect(section.type == .bigSquare)
  }
  
  @Test func testCompleteWorkflowWithUseCases() async throws {
      let mockRepository = MockSectionsRepository()
      let sampleSection = TestConstants.createSamplePodcastSection(
          name: "Trending Podcasts",
          type: .twoLinesGrid,
          contentCount: 3
      )
      await mockRepository.setMockSections([sampleSection])
      
      let useCase = DefaultFetchSectionsUseCase(sectionsRepository: mockRepository)
      let result = try await useCase.fetchSections(page: 1)
      
      #expect(result.sections.count == 1)
      #expect(result.sections.first?.name == "Trending Podcasts")
      #expect(result.sections.first?.type == .twoLinesGrid)
      #expect(result.sections.first?.content.count == 3)
  }
  
  @Test func testAllSectionTypesIntegration() {
      let allTypes: [SectionType] = [.square, .audiobookBigSquare, .bigSquare, .twoLinesGrid, .queue]
      let sections = allTypes.enumerated().map { index, type in
          TestConstants.createSamplePodcastSection(
              name: "Section \(index + 1)",
              type: type
          )
      }
      
      #expect(sections.count == 5)
      #expect(sections.map { $0.type }.contains(.square))
      #expect(sections.map { $0.type }.contains(.queue))
  }
  
  @Test func testEpisodeTypesIntegration() {
      let fullEpisodeContent = TestConstants.createSamplePodcastContent(name: "Full Episode")
      let trailerContent = TestConstants.createSamplePodcastContent(name: "Trailer")
      
      let modifiedFullContent = PodcastContent(
          podcastID: fullEpisodeContent.podcastID,
          name: fullEpisodeContent.name,
          description: fullEpisodeContent.description,
          avatarURL: fullEpisodeContent.avatarURL,
          episodeCount: fullEpisodeContent.episodeCount,
          duration: fullEpisodeContent.duration,
          priority: fullEpisodeContent.priority,
          popularityScore: fullEpisodeContent.popularityScore,
          score: fullEpisodeContent.score,
          language: fullEpisodeContent.language,
          podcastPopularityScore: fullEpisodeContent.podcastPopularityScore,
          podcastPriority: fullEpisodeContent.podcastPriority,
          episodeID: fullEpisodeContent.episodeID,
          seasonNumber: fullEpisodeContent.seasonNumber,
          episodeType: .full,
          podcastName: fullEpisodeContent.podcastName,
          authorName: fullEpisodeContent.authorName,
          number: fullEpisodeContent.number,
          separatedAudioURL: fullEpisodeContent.separatedAudioURL,
          audioURL: fullEpisodeContent.audioURL,
          releaseDate: fullEpisodeContent.releaseDate,
          chapters: fullEpisodeContent.chapters,
          paidIsEarlyAccess: fullEpisodeContent.paidIsEarlyAccess,
          paidIsNowEarlyAccess: fullEpisodeContent.paidIsNowEarlyAccess,
          paidIsExclusive: fullEpisodeContent.paidIsExclusive,
          paidTranscriptURL: fullEpisodeContent.paidTranscriptURL,
          freeTranscriptURL: fullEpisodeContent.freeTranscriptURL,
          paidIsExclusivePartially: fullEpisodeContent.paidIsExclusivePartially,
          paidExclusiveStartTime: fullEpisodeContent.paidExclusiveStartTime,
          paidEarlyAccessDate: fullEpisodeContent.paidEarlyAccessDate,
          paidEarlyAccessAudioURL: fullEpisodeContent.paidEarlyAccessAudioURL,
          paidExclusivityType: fullEpisodeContent.paidExclusivityType,
          audiobookID: fullEpisodeContent.audiobookID,
          articleID: fullEpisodeContent.articleID
      )
      
      #expect(modifiedFullContent.episodeType == .full)
  }
}
