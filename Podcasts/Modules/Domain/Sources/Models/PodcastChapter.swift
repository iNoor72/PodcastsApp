//
//  PodcastChapter.swift
//  Domain
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

public struct PodcastChapter: Hashable, Identifiable, Equatable {
    public var id: UUID = UUID()
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}
