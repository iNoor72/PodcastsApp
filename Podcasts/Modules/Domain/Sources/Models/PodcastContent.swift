//
//  PodcastContent.swift
//  Domain
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

public struct PodcastContent: Hashable, Identifiable, Equatable {
    public static func == (lhs: PodcastContent, rhs: PodcastContent) -> Bool {
        lhs.id == rhs.id
        && lhs.podcastID == rhs.podcastID
        && lhs.name == rhs.name
    }
    
    public let id: UUID = UUID()
    public let podcastID: String?
    public let name, description: String
    public let avatarURL: String
    public let episodeCount: Int?
    public let duration: Int
    public let priority, popularityScore: Int?
    public let score: Double
    public let language: String?
    public let podcastPopularityScore, podcastPriority: Int?
    public let episodeID: String?
    public let seasonNumber: Int?
    public let episodeType: EpisodeType?
    public let podcastName: String?
    public let authorName: String?
    public let number: Int?
    public let separatedAudioURL, audioURL: String?
    public let releaseDate: String?
    public let chapters: [PodcastChapter]?
    public let paidIsEarlyAccess, paidIsNowEarlyAccess, paidIsExclusive: Bool?
    public let paidTranscriptURL, freeTranscriptURL: String?
    public let paidIsExclusivePartially: Bool?
    public let paidExclusiveStartTime: Int?
    public let paidEarlyAccessDate, paidEarlyAccessAudioURL, paidExclusivityType: String?
    public let audiobookID: String?
    public let articleID: String?
    
    public init(podcastID: String?, name: String, description: String, avatarURL: String, episodeCount: Int?, duration: Int, priority: Int?, popularityScore: Int?, score: Double, language: String?, podcastPopularityScore: Int?, podcastPriority: Int?, episodeID: String?, seasonNumber: Int?, episodeType: EpisodeType?, podcastName: String?, authorName: String?, number: Int?, separatedAudioURL: String?, audioURL: String?, releaseDate: String?, chapters: [PodcastChapter]?, paidIsEarlyAccess: Bool?, paidIsNowEarlyAccess: Bool?, paidIsExclusive: Bool?, paidTranscriptURL: String?, freeTranscriptURL: String?, paidIsExclusivePartially: Bool?, paidExclusiveStartTime: Int?, paidEarlyAccessDate: String?, paidEarlyAccessAudioURL: String?, paidExclusivityType: String?, audiobookID: String?, articleID: String?) {
        self.podcastID = podcastID
        self.name = name
        self.description = description
        self.avatarURL = avatarURL
        self.episodeCount = episodeCount
        self.duration = duration
        self.priority = priority
        self.popularityScore = popularityScore
        self.score = score
        self.language = language
        self.podcastPopularityScore = podcastPopularityScore
        self.podcastPriority = podcastPriority
        self.episodeID = episodeID
        self.seasonNumber = seasonNumber
        self.episodeType = episodeType
        self.podcastName = podcastName
        self.authorName = authorName
        self.number = number
        self.separatedAudioURL = separatedAudioURL
        self.audioURL = audioURL
        self.releaseDate = releaseDate
        self.chapters = chapters
        self.paidIsEarlyAccess = paidIsEarlyAccess
        self.paidIsNowEarlyAccess = paidIsNowEarlyAccess
        self.paidIsExclusive = paidIsExclusive
        self.paidTranscriptURL = paidTranscriptURL
        self.freeTranscriptURL = freeTranscriptURL
        self.paidIsExclusivePartially = paidIsExclusivePartially
        self.paidExclusiveStartTime = paidExclusiveStartTime
        self.paidEarlyAccessDate = paidEarlyAccessDate
        self.paidEarlyAccessAudioURL = paidEarlyAccessAudioURL
        self.paidExclusivityType = paidExclusivityType
        self.audiobookID = audiobookID
        self.articleID = articleID
    }
}
