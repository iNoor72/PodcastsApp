//
//  SearchUseCase.swift
//  Domain
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

public protocol SearchUseCase {
    func search(with query: String) async throws -> [PodcastSection]?
}

public final class DefaultSearchUseCase: SearchUseCase {
    private let repository: SearchRepositoryProtocol
    
    public init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    public func search(with query: String) async throws -> [PodcastSection]? {
        return try await repository.search(query: query)
    }
}
