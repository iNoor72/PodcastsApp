//
//  MockSectionsRepository.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

actor MockSectionsRepository: SectionsRepositoryProtocol {
    private var mockSections: [PodcastSection] = []
    private var shouldThrowError = false
    private var errorToThrow: Error?
    
    func setMockSections(_ sections: [PodcastSection]) {
        self.mockSections = sections
    }
    
    func setShouldThrowError(_ shouldThrow: Bool, error: Error? = nil) {
        self.shouldThrowError = shouldThrow
        self.errorToThrow = error
    }
    
    func fetchSections(page: Int) async throws -> Domain.HomeScreenDataModel {
        if shouldThrowError {
            throw errorToThrow ?? MockError.testError
        }
        
        return HomeScreenDataModel(sections: [], totalPages: 0)
    }
    
    enum MockError: Error {
        case testError
    }
}
