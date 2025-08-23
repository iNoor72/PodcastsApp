//
//  TestConstants.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//


import Foundation
@testable import Domain

enum TestConstants {
    static let samplePodcastID = "test-podcast-123"
    static let sampleEpisodeID = "test-episode-456"
    static let sampleAvatarURL = "https://example.com/avatar.jpg"
    static let sampleAudioURL = "https://example.com/audio.mp3"
    static let sampleReleaseDate = "2024-01-15"
    static let sampleDuration = 3600
    static let sampleScore = 4.2
}

extension TestConstants {
    static func createSamplePodcastContent(
        name: String = "Sample Episode",
        duration: Int = sampleDuration,
        score: Double = sampleScore
    ) -> PodcastContent {
        return PodcastContent(
            podcastID: samplePodcastID,
            name: name,
            description: "Sample episode description",
            avatarURL: sampleAvatarURL,
            episodeCount: 25,
            duration: duration,
            priority: 1,
            popularityScore: 88,
            score: score,
            language: "en",
            podcastPopularityScore: 92,
            podcastPriority: 1,
            episodeID: sampleEpisodeID,
            seasonNumber: 1,
            episodeType: nil,
            podcastName: "Sample Podcast",
            authorName: "Sample Author",
            number: 10,
            separatedAudioURL: nil,
            audioURL: sampleAudioURL,
            releaseDate: sampleReleaseDate,
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
    
    static func createSamplePodcastSection(
        name: String = "Sample Section",
        type: SectionType = .square,
        contentCount: Int = 1
    ) -> PodcastSection {
        let content = Array(0..<contentCount).map { index in
            createSamplePodcastContent(name: "Content \(index + 1)")
        }
        
        return PodcastSection(
            name: name,
            type: type,
            contentType: "podcast",
            order: 1,
            content: content
        )
    }
}
