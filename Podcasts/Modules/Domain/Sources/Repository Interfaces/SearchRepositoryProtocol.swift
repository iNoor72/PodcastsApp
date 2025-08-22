//
//  SearchRepositoryProtocol.swift
//  Domain
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

public protocol SearchRepositoryProtocol {
    func search(query: String) async throws -> [PodcastSection]?
}
