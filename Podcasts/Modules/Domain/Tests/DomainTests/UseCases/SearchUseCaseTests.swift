//
//  SearchUseCaseTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

struct SearchUseCaseTests {
    @Test func testSearchRepositoryProtocolCompliance() async throws {
        let repository = MockSearchRepository()
        let mockResults = [TestConstants.createSamplePodcastSection(name: "Search Result")]
        await repository.setMockResults(mockResults)
        
        let result = try await repository.search(query: "test")
        
        #expect(result?.count == 1)
        #expect(result?.first?.name == "Search Result")
    }
  
  @Test func testSearchSuccess() async throws {
      let mockRepository = MockSearchRepository()
      let mockSections = [TestConstants.createSamplePodcastSection(name: "Search Result")]
      await mockRepository.setMockResults(mockSections)
      
      let useCase = DefaultSearchUseCase(repository: mockRepository)
      let result = try await useCase.search(with: "test query")
      
      #expect(result?.count == 1)
      #expect(result?.first?.name == "Search Result")
  }
  
  @Test func testSearchWithEmptyQuery() async throws {
      let mockRepository = MockSearchRepository()
      await mockRepository.setMockResults([])
      
      let useCase = DefaultSearchUseCase(repository: mockRepository)
      let result = try await useCase.search(with: "")
      
      #expect(result?.isEmpty == true)
  }
  
  @Test func testSearchWithNilResult() async throws {
      let mockRepository = MockSearchRepository()
      await mockRepository.setMockResults(nil)
      
      let useCase = DefaultSearchUseCase(repository: mockRepository)
      let result = try await useCase.search(with: "test")
      
      #expect(result == nil)
  }
  
  @Test func testSearchFailure() async throws {
      let mockRepository = MockSearchRepository()
      await mockRepository.setShouldThrowError(true)
      
      let useCase = DefaultSearchUseCase(repository: mockRepository)
      
      await #expect(throws: MockSearchRepository.MockError.self) {
          try await useCase.search(with: "test")
      }
  }
  
  @Test func testSearchWithSpecialCharacters() async throws {
      let mockRepository = MockSearchRepository()
      let specialQuery = "podcast@#$%^&*()"
      await mockRepository.setMockResults([])
      
      let useCase = DefaultSearchUseCase(repository: mockRepository)
      let result = try await useCase.search(with: specialQuery)
      
      #expect(result?.isEmpty == true)
  }
  
  @Test func testSearchWithLongQuery() async throws {
      let mockRepository = MockSearchRepository()
      let longQuery = String(repeating: "a", count: 1000)
      let mockSections = [TestConstants.createSamplePodcastSection()]
      await mockRepository.setMockResults(mockSections)
      
      let useCase = DefaultSearchUseCase(repository: mockRepository)
      let result = try await useCase.search(with: longQuery)
      
      #expect(result?.count == 1)
  }
  
  @Test func testSearchWithMultipleResults() async throws {
      let mockRepository = MockSearchRepository()
      let mockSections = [
          TestConstants.createSamplePodcastSection(name: "Result 1"),
          TestConstants.createSamplePodcastSection(name: "Result 2"),
          TestConstants.createSamplePodcastSection(name: "Result 3")
      ]
      await mockRepository.setMockResults(mockSections)
      
      let useCase = DefaultSearchUseCase(repository: mockRepository)
      let result = try await useCase.search(with: "test")
      
      #expect(result?.count == 3)
  }
}
