//
//  SectionsRepositoryProtocol.swift
//  Domain
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation

public protocol SectionsRepositoryProtocol: Sendable {
    func fetchSections(page: Int) async throws -> HomeScreenDataModel
}
