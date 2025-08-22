//
//  HomeScreenDataModel.swift
//  Domain
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import Foundation

public struct HomeScreenDataModel: Sendable, Hashable {
    public let sections: [PodcastSection]
    public let totalPages: Int
    
    public init(sections: [PodcastSection], totalPages: Int) {
        self.sections = sections
        self.totalPages = totalPages
    }
}
