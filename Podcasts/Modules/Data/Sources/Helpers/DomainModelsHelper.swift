//
//  DomainModelsHelper.swift
//  Data
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import Foundation
import Domain

struct DomainModelsHelper {
    static func convertToDomainModel(_ sections: [PodcastSectionResponse])
        -> [PodcastSection]
    {
        return sections.map(convertToDomainModel)
    }

    private static func convertToDomainModel(_ section: PodcastSectionResponse)
        -> PodcastSection
    {
        return PodcastSection(
            name: section.name,
            type: SectionType(rawValue: section.type) ?? .square,
            contentType: section.contentType,
            order: section.order,
            content: convertToDomainModel(section.content)
        )
    }

    static func convertToDomainModel(_ content: [PodcastContentResponse])
        -> [PodcastContent]
    {
        return content.map(convertToDomainModel)
    }

    private static func convertToDomainModel(_ content: PodcastContentResponse)
        -> PodcastContent
    {
        return PodcastContent(
            podcastID: content.podcastID,
            name: content.name,
            description: content.description,
            avatarURL: content.avatarURL,
            episodeCount: content.episodeCount,
            duration: content.duration,
            priority: content.priority,
            popularityScore: content.popularityScore,
            score: content.score,
            language: content.language,
            podcastPopularityScore: content.podcastPopularityScore,
            podcastPriority: content.podcastPriority,
            episodeID: content.episodeID,
            seasonNumber: content.seasonNumber,
            episodeType: EpisodeType(rawValue: content.episodeType?.rawValue ?? ""),
            podcastName: content.podcastName,
            authorName: content.authorName,
            number: content.number,
            separatedAudioURL: content.separatedAudioURL,
            audioURL: content.audioURL,
            releaseDate: content.releaseDate,
            chapters: convertToDomainModel(content.chapters),
            paidIsEarlyAccess: content.paidIsEarlyAccess,
            paidIsNowEarlyAccess: content.paidIsNowEarlyAccess,
            paidIsExclusive: content.paidIsExclusive,
            paidTranscriptURL: content.paidTranscriptURL,
            freeTranscriptURL: content.freeTranscriptURL,
            paidIsExclusivePartially: content.paidIsExclusivePartially,
            paidExclusiveStartTime: content.paidExclusiveStartTime,
            paidEarlyAccessDate: content.paidEarlyAccessDate,
            paidEarlyAccessAudioURL: content.paidEarlyAccessAudioURL,
            paidExclusivityType: content.paidExclusivityType,
            audiobookID: content.audiobookID,
            articleID: content.articleID
        )
    }

    static func convertToDomainModel(_ chapters: [PodcastChapterResponse]?)
        -> [PodcastChapter]?
    {
        return chapters?.map(convertToDomainModel) ?? []
    }

    private static func convertToDomainModel(_ chapter: PodcastChapterResponse)
        -> PodcastChapter
    {
        return PodcastChapter(title: chapter.title)
    }
    
    static func convertToDomainModel(_ searchSections: [SearchSectionResponse]) -> [SearchSection] {
        return searchSections.map(convertToDomainModel)
    }
    
    private static func convertToDomainModel(_ searchSection: SearchSectionResponse) -> SearchSection {
        return SearchSection(name: searchSection.name, type: SectionType(rawValue: searchSection.contentType) ?? .square, contentType: searchSection.contentType, order: searchSection.order, content: convertToDomainModel(searchSection.content))
    }
    
    static func convertToDomainModel(_ searchContent: [SearchContentResponse]) -> [PodcastContent] {
        return searchContent.map(convertToDomainModel)
    }
    
    private static func convertToDomainModel(_ searchContent: SearchContentResponse) -> PodcastContent {
        return PodcastContent(
            podcastID: searchContent.podcastID,
            name: searchContent.name,
            description: searchContent.description,
            avatarURL: searchContent.avatarURL,
            episodeCount: Int(searchContent.episodeCount) ?? 0,
            duration: Int(searchContent.duration) ?? 0,
            priority: Int(searchContent.priority) ?? 0,
            popularityScore: Int(searchContent.popularityScore) ?? 0,
            score: Double(searchContent.score) ?? 0,
            language: searchContent.language,
            podcastPopularityScore: nil,
            podcastPriority: nil,
            episodeID: nil,
            seasonNumber: nil,
            episodeType: .none,
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
    }
}
