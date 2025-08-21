//
//  PodcastSection.swift
//  Domain
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

public struct PodcastSection: Sendable, Hashable, Identifiable, Equatable {
    public static func == (lhs: PodcastSection, rhs: PodcastSection) -> Bool {
        lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.type == rhs.type
        && lhs.order == rhs.order
        && lhs.content == rhs.content
    }
    
    public let id: UUID = UUID()
    public let name, contentType: String
    public let type: SectionType
    public let order: Int
    public let content: [PodcastContent]
    
    public init(name: String, type: SectionType, contentType: String, order: Int, content: [PodcastContent]) {
        self.name = name
        self.type = type
        self.contentType = contentType
        self.order = order
        self.content = content
    }
}
