//
//  File.swift
//  Data
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation
import Domain
import NetworkLayer

public final class SearchRepository: SearchRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    public init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    public func search(query: String) async throws -> [SearchSection]? {
        let endpoint = SearchEndpoint.search(query: query)
        let result: Result<SearchResponse?, NetworkError> = await network.request(with: endpoint)
        
        switch result {
        case .success(let response):
            guard let sections = response?.sections else {
                return []
            }
            
            return DomainModelsHelper.convertToDomainModel(sections)
            
        case .failure(let error):
            throw error
        }
    }
}
