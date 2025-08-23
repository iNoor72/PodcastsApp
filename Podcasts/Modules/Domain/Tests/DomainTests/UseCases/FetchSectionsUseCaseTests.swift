//
//  FetchSectionsUseCaseTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

struct FetchSectionsUseCaseTests {
    
    @Test func testSectionsRepositoryProtocolCompliance() async throws {
        let repository = MockSectionsRepository()
        let mockSections = [TestConstants.createSamplePodcastSection()]
        await repository.setMockSections(mockSections)
        
        let result = try await repository.fetchSections(page: 1)
        
        #expect(result.sections.count == 1)
        #expect(result.sections.first?.name == "Sample Section")
    }
    
    @Test func testFetchSectionsSuccess() async throws {
        let mockRepository = MockSectionsRepository()
        let mockSections = [createMockPodcastSection()]
        await mockRepository.setMockSections(mockSections)
        
        let useCase = DefaultFetchSectionsUseCase(sectionsRepository: mockRepository)
        let result = try await useCase.fetchSections(page: 1)
        
        #expect(result.sections.count == 0)
        #expect(result.totalPages == 0)
    }
    
    @Test func testFetchSectionsFailure() async throws {
        let mockRepository = MockSectionsRepository()
        await mockRepository.setShouldThrowError(true)
        
        let useCase = DefaultFetchSectionsUseCase(sectionsRepository: mockRepository)
        
        await #expect(throws: MockSectionsRepository.MockError.self) {
            try await useCase.fetchSections(page: 1)
        }
    }
    
    @Test func testFetchSectionsWithDifferentPages() async throws {
        let mockRepository = MockSectionsRepository()
        let mockSections = [createMockPodcastSection()]
        await mockRepository.setMockSections(mockSections)
        
        let useCase = DefaultFetchSectionsUseCase(sectionsRepository: mockRepository)
        
        let page1Result = try await useCase.fetchSections(page: 1)
        let page2Result = try await useCase.fetchSections(page: 2)
        
        #expect(page1Result.sections.count == 1)
        #expect(page2Result.sections.count == 1)
    }
    
    @Test func testFetchSectionsEmptyResult() async throws {
        let mockRepository = MockSectionsRepository()
        await mockRepository.setMockSections([])
        
        let useCase = DefaultFetchSectionsUseCase(sectionsRepository: mockRepository)
        let result = try await useCase.fetchSections(page: 1)
        
        #expect(result.sections.isEmpty)
    }
    
    private func createMockPodcastSection() -> PodcastSection {
        let content = PodcastContent(
            podcastID: "123",
            name: "Mock Content",
            description: "Mock Description",
            avatarURL: "https://example.com/mock.jpg",
            episodeCount: 10,
            duration: 3600,
            priority: 1,
            popularityScore: 100,
            score: 4.5,
            language: "en",
            podcastPopularityScore: 90,
            podcastPriority: 1,
            episodeID: "ep123",
            seasonNumber: 1,
            episodeType: nil,
            podcastName: "Mock Podcast",
            authorName: "Mock Author",
            number: 1,
            separatedAudioURL: nil,
            audioURL: "https://example.com/audio.mp3",
            releaseDate: "2024-01-01",
            chapters: nil,
            paidIsEarlyAccess: false,
            paidIsNowEarlyAccess: false,
            paidIsExclusive: false,
            paidTranscriptURL: nil,
            freeTranscriptURL: nil,
            paidIsExclusivePartially: false,
            paidExclusiveStartTime: nil,
            paidEarlyAccessDate: nil,
            paidEarlyAccessAudioURL: nil,
            paidExclusivityType: nil,
            audiobookID: nil,
            articleID: nil
        )
        
        return PodcastSection(
            name: "Mock Section",
            type: .square,
            contentType: "podcast",
            order: 1,
            content: [content]
        )
    }
}
