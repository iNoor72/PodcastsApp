//
//  PodcastContentTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//


import Testing
import Foundation
@testable import Domain

struct PodcastContentTests {
    
    @Test func testPodcastContentInitialization() {
        let content = PodcastContent(
            podcastID: "podcast123",
            name: "Test Episode",
            description: "Test Episode Description",
            avatarURL: "https://example.com/avatar.jpg",
            episodeCount: 50,
            duration: 2400,
            priority: 5,
            popularityScore: 85,
            score: 4.2,
            language: "en",
            podcastPopularityScore: 78,
            podcastPriority: 3,
            episodeID: "episode456",
            seasonNumber: 2,
            episodeType: nil,
            podcastName: "Amazing Podcast",
            authorName: "John Doe",
            number: 15,
            separatedAudioURL: "https://example.com/separated.mp3",
            audioURL: "https://example.com/audio.mp3",
            releaseDate: "2024-03-15",
            chapters: nil,
            paidIsEarlyAccess: true,
            paidIsNowEarlyAccess: false,
            paidIsExclusive: true,
            paidTranscriptURL: "https://example.com/transcript.txt",
            freeTranscriptURL: nil,
            paidIsExclusivePartially: false,
            paidExclusiveStartTime: 300,
            paidEarlyAccessDate: "2024-03-10",
            paidEarlyAccessAudioURL: "https://example.com/early.mp3",
            paidExclusivityType: "premium",
            audiobookID: "audiobook789",
            articleID: "article101"
        )
        
        #expect(content.podcastID == "podcast123")
        #expect(content.name == "Test Episode")
        #expect(content.description == "Test Episode Description")
        #expect(content.avatarURL == "https://example.com/avatar.jpg")
        #expect(content.episodeCount == 50)
        #expect(content.duration == 2400)
        #expect(content.priority == 5)
        #expect(content.popularityScore == 85)
        #expect(content.score == 4.2)
        #expect(content.language == "en")
        #expect(content.paidIsEarlyAccess == true)
        #expect(content.paidIsExclusive == true)
        #expect(content.audiobookID == "audiobook789")
        #expect(content.articleID == "article101")
    }
    
    @Test func testPodcastContentEquality() {
        let content1 = createMinimalPodcastContent()
        let content2 = createMinimalPodcastContent()
        
        #expect(content1 != content2)
    }
    
    @Test func testPodcastContentHashable() {
        let content = createMinimalPodcastContent()
        let set: Set<PodcastContent> = [content]
        
        #expect(set.count == 1)
    }
    
    @Test func testPodcastContentWithNilValues() {
        let content = PodcastContent(
            podcastID: nil,
            name: "Minimal Episode",
            description: "Minimal Description",
            avatarURL: "https://example.com/minimal.jpg",
            episodeCount: nil,
            duration: 1800,
            priority: nil,
            popularityScore: nil,
            score: 3.0,
            language: nil,
            podcastPopularityScore: nil,
            podcastPriority: nil,
            episodeID: nil,
            seasonNumber: nil,
            episodeType: nil,
            podcastName: nil,
            authorName: nil,
            number: nil,
            separatedAudioURL: nil,
            audioURL: nil,
            releaseDate: nil,
            chapters: nil,
            paidIsEarlyAccess: nil,
            paidIsNowEarlyAccess: nil,
            paidIsExclusive: nil,
            paidTranscriptURL: nil,
            freeTranscriptURL: nil,
            paidIsExclusivePartially: nil,
            paidExclusiveStartTime: nil,
            paidEarlyAccessDate: nil,
            paidEarlyAccessAudioURL: nil,
            paidExclusivityType: nil,
            audiobookID: nil,
            articleID: nil
        )
        
        #expect(content.podcastID == nil)
        #expect(content.episodeCount == nil)
        #expect(content.priority == nil)
        #expect(content.language == nil)
        #expect(content.audioURL == nil)
        #expect(content.paidIsEarlyAccess == nil)
    }
    
    private func createMinimalPodcastContent() -> PodcastContent {
        return PodcastContent(
            podcastID: "123",
            name: "Test",
            description: "Description",
            avatarURL: "https://example.com/test.jpg",
            episodeCount: 1,
            duration: 60,
            priority: 1,
            popularityScore: 1,
            score: 1.0,
            language: "en",
            podcastPopularityScore: 1,
            podcastPriority: 1,
            episodeID: "ep1",
            seasonNumber: 1,
            episodeType: nil,
            podcastName: "Test Podcast",
            authorName: "Test Author",
            number: 1,
            separatedAudioURL: nil,
            audioURL: nil,
            releaseDate: nil,
            chapters: nil,
            paidIsEarlyAccess: nil,
            paidIsNowEarlyAccess: nil,
            paidIsExclusive: nil,
            paidTranscriptURL: nil,
            freeTranscriptURL: nil,
            paidIsExclusivePartially: nil,
            paidExclusiveStartTime: nil,
            paidEarlyAccessDate: nil,
            paidEarlyAccessAudioURL: nil,
            paidExclusivityType: nil,
            audiobookID: nil,
            articleID: nil
        )
    }
}
