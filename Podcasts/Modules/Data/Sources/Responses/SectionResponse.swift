//
//  SectionResponse.swift
//  HomeScreen
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

struct SectionsResponse: Codable {
    let sections: [PodcastSectionResponse]
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let nextPage: String
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case totalPages = "total_pages"
    }
}

// MARK: - Section
struct PodcastSectionResponse: Codable {
    let name, type, contentType: String
    let order: Int
    let content: [PodcastContentResponse]
    
    enum CodingKeys: String, CodingKey {
        case name, type
        case contentType = "content_type"
        case order, content
    }
}

struct PodcastChapterResponse: Codable {
    let title: String
}

// MARK: - Content
struct PodcastContentResponse: Codable {
    // Podcast fields
    let podcastID: String?
    let name, description: String
    let avatarURL: String
    let episodeCount: Int?
    let duration: Int
    let priority, popularityScore: Int?
    let score: Double
    let language: String?
    
    // Episode fields
    let podcastPopularityScore, podcastPriority: Int?
    let episodeID: String?
    let seasonNumber: Int?
    let episodeType: EpisodeTypeResponse?
    let podcastName: String?
    let authorName: String?
    let number: Int?
    let separatedAudioURL, audioURL: String?
    let releaseDate: String?
    let chapters: [PodcastChapterResponse]?
    let paidIsEarlyAccess, paidIsNowEarlyAccess, paidIsExclusive: Bool?
    let paidTranscriptURL, freeTranscriptURL: String?
    let paidIsExclusivePartially: Bool?
    let paidExclusiveStartTime: Int?
    let paidEarlyAccessDate, paidEarlyAccessAudioURL, paidExclusivityType: String?
    
    // Audiobook fields
    let audiobookID: String?
    
    // Article fields
    let articleID: String?
    
    enum CodingKeys: String, CodingKey {
        case podcastID = "podcast_id"
        case name, description
        case avatarURL = "avatar_url"
        case episodeCount = "episode_count"
        case duration
        case priority
        case popularityScore = "popularityScore"  // Fixed: matches JSON exactly
        case score, language
        case podcastPopularityScore = "podcastPopularityScore"  // Fixed: matches JSON exactly
        case podcastPriority = "podcastPriority"  // Fixed: matches JSON exactly
        case episodeID = "episode_id"
        case seasonNumber = "season_number"
        case episodeType = "episode_type"
        case podcastName = "podcast_name"
        case authorName = "author_name"
        case number
        case separatedAudioURL = "separated_audio_url"
        case audioURL = "audio_url"
        case releaseDate = "release_date"
        case chapters
        case paidIsEarlyAccess = "paid_is_early_access"
        case paidIsNowEarlyAccess = "paid_is_now_early_access"
        case paidIsExclusive = "paid_is_exclusive"
        case paidTranscriptURL = "paid_transcript_url"
        case freeTranscriptURL = "free_transcript_url"
        case paidIsExclusivePartially = "paid_is_exclusive_partially"
        case paidExclusiveStartTime = "paid_exclusive_start_time"
        case paidEarlyAccessDate = "paid_early_access_date"
        case paidEarlyAccessAudioURL = "paid_early_access_audio_url"
        case paidExclusivityType = "paid_exclusivity_type"
        case audiobookID = "audiobook_id"
        case articleID = "article_id"
    }
}

enum EpisodeTypeResponse: String, Codable {
    case full = "full"
    case trailer = "trailer"
}
