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

    static func convertToDomainModel(_ section: PodcastSectionResponse)
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

    static func convertToDomainModel(_ content: PodcastContentResponse)
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

    static func convertToDomainModel(_ chapter: PodcastChapterResponse)
        -> PodcastChapter
    {
        return PodcastChapter(title: chapter.title)
    }
}
