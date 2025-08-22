//
//  SearchSection.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation

public struct SearchSection: Hashable, Identifiable, Equatable {
    public static func == (lhs: SearchSection, rhs: SearchSection) -> Bool {
        lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.type == rhs.type
        && lhs.order == rhs.order
        && lhs.content == rhs.content
    }
    
    public let id: UUID = UUID()
    public let name, contentType: String
    public let type: SectionType
    public let order: String
    public let content: [PodcastContent]
    
    public init(name: String, type: SectionType, contentType: String, order: String, content: [PodcastContent]) {
        self.name = name
        self.type = type
        self.contentType = contentType
        self.order = order
        self.content = content
    }
}
