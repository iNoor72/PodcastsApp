//
//  FetchSectionsUseCase.swift
//  Domain
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

public protocol FetchSectionsUseCase: Sendable {
    func fetchSections(page: Int) async throws -> [PodcastSection]
}

public final class DefaultFetchSectionsUseCase: FetchSectionsUseCase {
    private let sectionsRepository: SectionsRepositoryProtocol
    
    public init(sectionsRepository: SectionsRepositoryProtocol) {
        self.sectionsRepository = sectionsRepository
    }
    
    public func fetchSections(page: Int) async throws -> [PodcastSection] {
        return try await sectionsRepository.fetchSections(page: page)
    }
}
