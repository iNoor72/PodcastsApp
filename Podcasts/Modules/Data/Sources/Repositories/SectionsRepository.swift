//
//  SectionsRepository.swift
//  Data
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Domain
import Foundation
@preconcurrency import NetworkLayer

public final class SectionsRepository: SectionsRepositoryProtocol {
    nonisolated(unsafe) private let network: NetworkServiceProtocol

    public init(network: NetworkServiceProtocol) {
        self.network = network
    }

    public func fetchSections(page: Int) async throws -> [PodcastSection] {
        let endpoint = SectionsEnpoint.fetchSections(page: page)
        let result: Result<SectionsResponse, NetworkError> = await network.request(with: endpoint)

        switch result {
        case .success(let response):
            return DomainModelsHelper.convertToDomainModel(response.sections)

        case .failure(let error):
            throw error
        }
    }
}
