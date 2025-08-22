//
//  SearchResponse.swift
//  Data
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

struct SearchResponse: Codable {
    let sections: [SearchSectionResponse]
}

// MARK: - Section
struct SearchSectionResponse: Codable {
    let name, type, contentType, order: String
    let content: [SearchContentResponse]

    enum CodingKeys: String, CodingKey {
        case name, type
        case contentType = "content_type"
        case order, content
    }
}

struct SearchContentResponse: Codable {
    let podcastID, name, description: String
    let avatarURL: String
    let episodeCount, duration, language, priority: String
    let popularityScore, score: String

    enum CodingKeys: String, CodingKey {
        case podcastID = "podcast_id"
        case name, description
        case avatarURL = "avatar_url"
        case episodeCount = "episode_count"
        case duration, language, priority, popularityScore, score
    }
}
