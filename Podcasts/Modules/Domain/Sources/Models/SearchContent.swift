//
//  SearchContent.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation

public struct SearchContent: Hashable, Equatable, Identifiable {
    public static func == (lhs: SearchContent, rhs: SearchContent) -> Bool {
        lhs.id == rhs.id
        && lhs.podcastID == rhs.podcastID
        && lhs.name == rhs.name
    }
    
    public let id = UUID()
    public let podcastID, name, description: String
    public let avatarURL: String
    public let episodeCount, duration, language, priority: String
    public let popularityScore, score: String
    
    public init(podcastID: String, name: String, description: String, avatarURL: String, episodeCount: String, duration: String, language: String, priority: String, popularityScore: String, score: String) {
        self.podcastID = podcastID
        self.name = name
        self.description = description
        self.avatarURL = avatarURL
        self.episodeCount = episodeCount
        self.duration = duration
        self.language = language
        self.priority = priority
        self.popularityScore = popularityScore
        self.score = score
    }
}
