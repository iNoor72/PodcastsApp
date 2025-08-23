//
//  MockSearchRepository.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

actor MockSearchRepository: SearchRepositoryProtocol {
    func search(query: String) async throws -> [Domain.SearchSection]? {
        if shouldThrowError {
            throw errorToThrow ?? MockError.searchFailed
        }
        
        return []
    }
    
  private var mockResults: [PodcastSection]?
  private var shouldThrowError = false
  private var errorToThrow: Error?
  
  func setMockResults(_ results: [PodcastSection]?) {
      self.mockResults = results
  }
  
  func setShouldThrowError(_ shouldThrow: Bool, error: Error? = nil) {
      self.shouldThrowError = shouldThrow
      self.errorToThrow = error
  }
  
  enum MockError: Error {
      case searchFailed
      case networkError
  }
}


