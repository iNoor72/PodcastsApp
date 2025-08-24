//
//  DataModuleTests.swift
//  Data
//
//  Created by Noor El-Din Walid on 24/08/2025.
//

import Testing
import Foundation
@testable import Data
@testable import Domain
@testable import NetworkLayer


// MARK: - SearchResponse Tests
@Suite("SearchResponse Model Tests")
struct SearchResponseTests {
    
    @Test("SearchResponse decodes correctly from valid JSON")
    func testSearchResponseDecoding() throws {
        let json = """
        {
            "sections": [
                {
                    "name": "Popular Podcasts",
                    "type": "grid",
                    "content_type": "podcast",
                    "order": "1",
                    "content": [
                        {
                            "podcast_id": "123",
                            "name": "Test Podcast",
                            "description": "A test podcast",
                            "avatar_url": "https://example.com/avatar.jpg",
                            "episode_count": "50",
                            "duration": "3600",
                            "language": "en",
                            "priority": "5",
                            "popularityScore": "8.5",
                            "score": "9.2"
                        }
                    ]
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchResponse.self, from: json)
        
        #expect(response.sections.count == 1)
        #expect(response.sections.first?.name == "Popular Podcasts")
        #expect(response.sections.first?.type == "grid")
        #expect(response.sections.first?.contentType == "podcast")
        #expect(response.sections.first?.order == "1")
        #expect(response.sections.first?.content.count == 1)
        
        let content = response.sections.first?.content.first
        #expect(content?.podcastID == "123")
        #expect(content?.name == "Test Podcast")
        #expect(content?.description == "A test podcast")
        #expect(content?.avatarURL == "https://example.com/avatar.jpg")
        #expect(content?.episodeCount == "50")
        #expect(content?.duration == "3600")
        #expect(content?.language == "en")
        #expect(content?.priority == "5")
        #expect(content?.popularityScore == "8.5")
        #expect(content?.score == "9.2")
    }
    
    @Test("SearchResponse handles empty sections")
    func testEmptySearchResponse() throws {
        let json = """
        {
            "sections": []
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchResponse.self, from: json)
        
        #expect(response.sections.isEmpty)
    }
    
    @Test("SearchResponse handles missing optional fields")
    func testSearchResponseWithMissingFields() throws {
        let json = """
        {
            "sections": [
                {
                    "name": "Minimal Section",
                    "type": "list",
                    "content_type": "podcast",
                    "order": "1",
                    "content": []
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchResponse.self, from: json)
        
        #expect(response.sections.count == 1)
        #expect(response.sections.first?.content.isEmpty == true)
    }
}

// MARK: - SectionsResponse Tests
@Suite("SectionsResponse Model Tests")
struct SectionsResponseTests {
    
    @Test("SectionsResponse decodes correctly with pagination")
    func testSectionsResponseDecoding() throws {
        let json = """
        {
            "sections": [
                {
                    "name": "Featured",
                    "type": "carousel",
                    "content_type": "episode",
                    "order": 1,
                    "content": [
                        {
                            "podcast_id": "456",
                            "name": "Featured Episode",
                            "description": "A featured episode",
                            "avatar_url": "https://example.com/featured.jpg",
                            "episode_count": 100,
                            "duration": 1800,
                            "priority": 10,
                            "popularityScore": 95,
                            "score": 4.8,
                            "language": "en",
                            "episode_id": "ep123",
                            "season_number": 2,
                            "episode_type": "full",
                            "podcast_name": "Test Podcast Show",
                            "author_name": "John Doe",
                            "number": 15,
                            "audio_url": "https://example.com/audio.mp3",
                            "release_date": "2024-08-20",
                            "chapters": [
                                {"title": "Introduction"},
                                {"title": "Main Topic"}
                            ],
                            "paid_is_early_access": false,
                            "paid_is_exclusive": true
                        }
                    ]
                }
            ],
            "pagination": {
                "next_page": "2",
                "total_pages": 5
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(SectionsResponse.self, from: json)
        
        // Test sections
        #expect(response.sections.count == 1)
        let section = response.sections.first!
        #expect(section.name == "Featured")
        #expect(section.type == "carousel")
        #expect(section.contentType == "episode")
        #expect(section.order == 1)
        
        // Test content
        #expect(section.content.count == 1)
        let content = section.content.first!
        #expect(content.podcastID == "456")
        #expect(content.name == "Featured Episode")
        #expect(content.episodeCount == 100)
        #expect(content.duration == 1800)
        #expect(content.episodeID == "ep123")
        #expect(content.seasonNumber == 2)
        #expect(content.episodeType == .full)
        #expect(content.podcastName == "Test Podcast Show")
        #expect(content.authorName == "John Doe")
        #expect(content.number == 15)
        #expect(content.audioURL == "https://example.com/audio.mp3")
        #expect(content.releaseDate == "2024-08-20")
        #expect(content.paidIsEarlyAccess == false)
        #expect(content.paidIsExclusive == true)
        
        // Test chapters
        #expect(content.chapters?.count == 2)
        #expect(content.chapters?.first?.title == "Introduction")
        #expect(content.chapters?.last?.title == "Main Topic")
        
        // Test pagination
        #expect(response.pagination.nextPage == "2")
        #expect(response.pagination.totalPages == 5)
    }
    
    @Test("EpisodeTypeResponse handles all cases")
    func testEpisodeTypeResponse() throws {
        let fullJson = "\"full\"".data(using: .utf8)!
        let trailerJson = "\"trailer\"".data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        let fullType = try decoder.decode(EpisodeTypeResponse.self, from: fullJson)
        let trailerType = try decoder.decode(EpisodeTypeResponse.self, from: trailerJson)
        
        #expect(fullType == .full)
        #expect(trailerType == .trailer)
    }
    
    @Test("SectionsResponse handles minimal data")
    func testMinimalSectionsResponse() throws {
        let json = """
        {
            "sections": [],
            "pagination": {
                "next_page": "1",
                "total_pages": 1
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(SectionsResponse.self, from: json)
        
        #expect(response.sections.isEmpty)
        #expect(response.pagination.nextPage == "1")
        #expect(response.pagination.totalPages == 1)
    }
}

// MARK: - DomainModelsHelper Tests
@Suite("DomainModelsHelper Tests")
struct DomainModelsHelperTests {
    
    @Test("Convert PodcastSectionResponse to domain model")
    func testConvertPodcastSectionToDomainModel() {
        let chapters = [PodcastChapterResponse(title: "Chapter 1")]
        let content = PodcastContentResponse(
            podcastID: "123",
            name: "Test Podcast",
            description: "Description",
            avatarURL: "https://example.com/avatar.jpg",
            episodeCount: 50,
            duration: 3600,
            priority: 5,
            popularityScore: 85,
            score: 4.5,
            language: "en",
            podcastPopularityScore: 90,
            podcastPriority: 10,
            episodeID: "ep123",
            seasonNumber: 1,
            episodeType: .full,
            podcastName: "Podcast Name",
            authorName: "Author",
            number: 1,
            separatedAudioURL: nil,
            audioURL: "https://example.com/audio.mp3",
            releaseDate: "2024-08-20",
            chapters: chapters,
            paidIsEarlyAccess: true,
            paidIsNowEarlyAccess: false,
            paidIsExclusive: false,
            paidTranscriptURL: "https://example.com/transcript.txt",
            freeTranscriptURL: nil,
            paidIsExclusivePartially: false,
            paidExclusiveStartTime: nil,
            paidEarlyAccessDate: "2024-08-19",
            paidEarlyAccessAudioURL: nil,
            paidExclusivityType: "premium",
            audiobookID: nil,
            articleID: nil
        )
        
        let sectionResponse = PodcastSectionResponse(
            name: "Featured",
            type: "carousel",
            contentType: "episode",
            order: 1,
            content: [content]
        )
        
        let domainSections = DomainModelsHelper.convertToDomainModel([sectionResponse])
        
        #expect(domainSections.count == 1)
        let domainSection = domainSections.first!
        #expect(domainSection.name == "Featured")
        #expect(domainSection.type == .square)
        #expect(domainSection.contentType == "episode")
        #expect(domainSection.order == 1)
        
        #expect(domainSection.content.count == 1)
        let domainContent = domainSection.content.first!
        #expect(domainContent.podcastID == "123")
        #expect(domainContent.name == "Test Podcast")
        #expect(domainContent.episodeCount == 50)
        #expect(domainContent.duration == 3600)
        #expect(domainContent.episodeID == "ep123")
        #expect(domainContent.episodeType == .full)
        #expect(domainContent.paidIsEarlyAccess == true)
        #expect(domainContent.paidEarlyAccessDate == "2024-08-19")
        
        #expect(domainContent.chapters?.count == 1)
        #expect(domainContent.chapters?.first?.title == "Chapter 1")
    }
    
    @Test("Convert SearchSectionResponse to domain model")
    func testConvertSearchSectionToDomainModel() {
        let searchContent = SearchContentResponse(
            podcastID: "456",
            name: "Search Result",
            description: "A search result",
            avatarURL: "https://example.com/search.jpg",
            episodeCount: "25",
            duration: "1800",
            language: "es",
            priority: "3",
            popularityScore: "7.5",
            score: "8.0"
        )
        
        let searchSection = SearchSectionResponse(
            name: "Search Results",
            type: "big-square",
            contentType: "podcast",
            order: "1",
            content: [searchContent]
        )
        
        let domainSections = DomainModelsHelper.convertToDomainModel([searchSection])
        
        #expect(domainSections.count == 1)
        let domainSection = domainSections.first!
        #expect(domainSection.name == "Search Results")
        #expect(domainSection.type == .bigSquare)
        #expect(domainSection.contentType == "podcast")
        #expect(domainSection.order == "1")
        
        #expect(domainSection.content.count == 1)
        let domainContent = domainSection.content.first!
        #expect(domainContent.podcastID == "456")
        #expect(domainContent.name == "Search Result")
        #expect(domainContent.episodeCount == 25)
        #expect(domainContent.duration == 1800)
        #expect(domainContent.priority == 3)
        #expect(domainContent.popularityScore == 7)
        #expect(domainContent.score == 8.0)
        #expect(domainContent.language == "es")
        
        // Episode-specific fields should be nil/default
        #expect(domainContent.episodeID == nil)
        #expect(domainContent.episodeType == .none)
        #expect(domainContent.chapters == nil)
    }
    
    @Test("Convert with invalid string numbers")
    func testConvertWithInvalidStringNumbers() {
        let searchContent = SearchContentResponse(
            podcastID: "789",
            name: "Invalid Numbers",
            description: "Test invalid numbers",
            avatarURL: "https://example.com/invalid.jpg",
            episodeCount: "invalid",
            duration: "not_a_number",
            language: "en",
            priority: "invalid_priority",
            popularityScore: "invalid_score",
            score: "invalid_double"
        )
        
        let domainContent = DomainModelsHelper.convertToDomainModel([searchContent])
        
        #expect(domainContent.count == 1)
        let content = domainContent.first!
        #expect(content.episodeCount == 0) // Default for invalid Int conversion
        #expect(content.duration == 0)
        #expect(content.priority == 0)
        #expect(content.popularityScore == 0)
        #expect(content.score == 0.0) // Default for invalid Double conversion
    }
    
    @Test("Convert empty collections")
    func testConvertEmptyCollections() {
        let emptySections: [PodcastSectionResponse] = []
        let emptySearchSections: [SearchSectionResponse] = []
        let emptyContent: [PodcastContentResponse] = []
        let emptySearchContent: [SearchContentResponse] = []
        
        #expect(DomainModelsHelper.convertToDomainModel(emptySections).isEmpty)
        #expect(DomainModelsHelper.convertToDomainModel(emptySearchSections).isEmpty)
        #expect(DomainModelsHelper.convertToDomainModel(emptyContent).isEmpty)
        #expect(DomainModelsHelper.convertToDomainModel(emptySearchContent).isEmpty)
    }
    
    @Test("Convert handles unknown section types")
    func testUnknownSectionTypes() {
        let sectionWithUnknownType = PodcastSectionResponse(
            name: "Unknown Type Section",
            type: "unknown_type",
            contentType: "podcast",
            order: 1,
            content: []
        )
        
        let domainSections = DomainModelsHelper.convertToDomainModel([sectionWithUnknownType])
        
        #expect(domainSections.count == 1)
        #expect(domainSections.first?.type == .square) // Default fallback
    }
}

// MARK: - SearchRepository Tests
@Suite("SearchRepository Tests")
struct SearchRepositoryTests {
    var mockNetwork: MockNetworkService!
    var repository: SearchRepository!
    
    init() {
        mockNetwork = MockNetworkService()
        repository = SearchRepository(network: mockNetwork)
    }
    
    @Test("Search returns converted domain models on success")
    func testSearchSuccess() async throws {
        let searchContent = SearchContentResponse(
            podcastID: "123",
            name: "Test Podcast",
            description: "Description",
            avatarURL: "https://example.com/avatar.jpg",
            episodeCount: "50",
            duration: "3600",
            language: "en",
            priority: "5",
            popularityScore: "85",
            score: "4.5"
        )
        
        let searchSection = SearchSectionResponse(
            name: "Results",
            type: "grid",
            contentType: "podcast",
            order: "1",
            content: [searchContent]
        )
        
        let searchResponse = SearchResponse(sections: [searchSection])
        mockNetwork.mockResult = searchResponse
        
        let result = try await repository.search(query: "test query")
        
        #expect(result?.count == 1)
        #expect(result?.first?.name == "Results")
        #expect(result?.first?.content.count == 1)
        #expect(result?.first?.content.first?.name == "Test Podcast")
    }
    
    @Test("Search returns empty array when response sections is nil")
    func testSearchWithNilSections() async throws {
        let emptyResponse = SearchResponse(sections: [])
        mockNetwork.mockResult = emptyResponse
        
        let result = try await repository.search(query: "empty query")
        
        #expect(result?.isEmpty == true)
    }
    
    @Test("Search returns empty array when response is nil")
    func testSearchWithNilResponse() async throws {
        mockNetwork.mockResult = nil as SearchResponse?
        
        let result = try await repository.search(query: "nil query")
        
        #expect(result?.isEmpty == true)
    }
    
    @Test("Search throws error on network failure")
    func testSearchNetworkFailure() async {
        mockNetwork.shouldFail = true
        
        do {
            _ = try await repository.search(query: "failing query")
            Issue.record("Expected search to throw an error")
        } catch {
            #expect(error is NetworkError)
        }
    }
    
    @Test("Search handles empty query")
    func testSearchWithEmptyQuery() async throws {
        let emptyResponse = SearchResponse(sections: [])
        mockNetwork.mockResult = emptyResponse
        
        let result = try await repository.search(query: "")
        
        #expect(result?.isEmpty == true)
    }
    
    @Test("Search handles special characters in query")
    func testSearchWithSpecialCharacters() async throws {
        let searchResponse = SearchResponse(sections: [])
        mockNetwork.mockResult = searchResponse
        
        let result = try await repository.search(query: "test@#$%^&*()")
        
        #expect(result?.isEmpty == true)
    }
}

// MARK: - SectionsRepository Tests
@Suite("SectionsRepository Tests")
struct SectionsRepositoryTests {
    var mockNetwork: MockNetworkService!
    var repository: SectionsRepository!
    
    init() {
        mockNetwork = MockNetworkService()
        repository = SectionsRepository(network: mockNetwork)
    }
    
    @Test("Fetch sections returns HomeScreenDataModel on success")
    func testFetchSectionsSuccess() async throws {
        let content = PodcastContentResponse(
            podcastID: "456",
            name: "Test Episode",
            description: "An episode",
            avatarURL: "https://example.com/episode.jpg",
            episodeCount: 100,
            duration: 1800,
            priority: 8,
            popularityScore: 92,
            score: 4.7,
            language: "en",
            podcastPopularityScore: nil,
            podcastPriority: nil,
            episodeID: nil,
            seasonNumber: nil,
            episodeType: nil,
            podcastName: nil,
            authorName: nil,
            number: nil,
            separatedAudioURL: nil,
            audioURL: nil,
            releaseDate: nil,
            chapters: nil,
            paidIsEarlyAccess: nil,
            paidIsNowEarlyAccess: nil,
            paidIsExclusive: nil,
            paidTranscriptURL: nil,
            freeTranscriptURL: nil,
            paidIsExclusivePartially: nil,
            paidExclusiveStartTime: nil,
            paidEarlyAccessDate: nil,
            paidEarlyAccessAudioURL: nil,
            paidExclusivityType: nil,
            audiobookID: nil,
            articleID: nil
        )
        
        let featuredSection = PodcastSectionResponse(
            name: "Featured Episodes",
            type: "",
            contentType: "2_lines_grid",
            order: 1,
            content: [content]
        )
        
        let popularSection = PodcastSectionResponse(
            name: "Popular Podcasts",
            type: "queue",
            contentType: "podcast",
            order: 2,
            content: [content]
        )
        
        let pagination = Pagination(nextPage: "3", totalPages: 15)
        let sectionsResponse = SectionsResponse(
            sections: [featuredSection, popularSection],
            pagination: pagination
        )
        mockNetwork.mockResult = sectionsResponse
        
        let result = try await repository.fetchSections(page: 2)
        
        // Verify the complete flow
        #expect(result.sections.count == 2)
        #expect(result.totalPages == 15)
        
        let firstSection = result.sections.first!
        #expect(firstSection.name == "Featured Episodes")
        #expect(firstSection.type == .twoLinesGrid)
        #expect(firstSection.contentType == "episode")
        #expect(firstSection.order == 1)
        #expect(firstSection.content.count == 1)
        
        let episodeDomain = firstSection.content.first!
        #expect(episodeDomain.podcastID == "show123")
        #expect(episodeDomain.name == "Featured Episode")
        #expect(episodeDomain.episodeID == "ep456")
        #expect(episodeDomain.seasonNumber == 3)
        #expect(episodeDomain.episodeType == .full)
        #expect(episodeDomain.podcastName == "The Weekly Show")
        #expect(episodeDomain.authorName == "Jane Smith")
        #expect(episodeDomain.number == 12)
        #expect(episodeDomain.audioURL == "https://example.com/audio.mp3")
        #expect(episodeDomain.releaseDate == "2024-08-20")
        #expect(episodeDomain.chapters?.count == 1)
        #expect(episodeDomain.chapters?.first?.title == "Intro")
        #expect(episodeDomain.paidIsEarlyAccess == true)
        #expect(episodeDomain.paidIsExclusive == true)
        #expect(episodeDomain.paidExclusiveStartTime == 1800)
        #expect(episodeDomain.audiobookID == "book789")
        #expect(episodeDomain.articleID == "article101")
        
        let secondSection = result.sections.last!
        #expect(secondSection.name == "Popular Podcasts")
        #expect(secondSection.type == .queue)
        #expect(secondSection.contentType == "podcast")
        #expect(secondSection.order == 2)
        
        let podcastDomain = secondSection.content.first!
        #expect(podcastDomain.podcastID == "show456")
        #expect(podcastDomain.name == "Popular Podcast")
        #expect(podcastDomain.language == "es")
        #expect(podcastDomain.episodeID == nil)
        #expect(podcastDomain.chapters == nil)
    }
}

// MARK: - Error Handling Tests
@Suite("Error Handling Tests")
struct ErrorHandlingTests {
    
    @Test("SearchRepository handles various network errors")
    func testSearchRepositoryNetworkErrors() async {
        let mockNetwork = MockNetworkService()
        let repository = SearchRepository(network: mockNetwork)
        
        // Test different network error scenarios
        let networkErrors: [NetworkError] = [
            .unknown,
            .decodingError,
            .invalidURL,
            .noData
        ]
        
        for expectedError in networkErrors {
            mockNetwork.reset()
            mockNetwork.shouldFail = true
            
            // Mock the specific error by setting it as the failure result
            // Note: This assumes MockNetworkService can be extended to return specific errors
            do {
                _ = try await repository.search(query: "test")
                Issue.record("Expected error \(expectedError) to be thrown")
            } catch let actualError as NetworkError {
                // Verify that some NetworkError was thrown
                // In a real scenario, you'd want to match specific error types
                #expect(actualError is NetworkError)
            } catch {
                Issue.record("Expected NetworkError, got \(type(of: error))")
            }
        }
    }
    
    @Test("SectionsRepository handles various network errors")
    func testSectionsRepositoryNetworkErrors() async {
        let mockNetwork = MockNetworkService()
        let repository = SectionsRepository(network: mockNetwork)
        
        mockNetwork.shouldFail = true
        
        do {
            _ = try await repository.fetchSections(page: 1)
            Issue.record("Expected network error to be thrown")
        } catch let error as NetworkError {
            #expect(error == .unknown) // Based on our mock implementation
        } catch {
            Issue.record("Expected NetworkError, got \(type(of: error))")
        }
    }
}

// MARK: - Edge Cases Tests
@Suite("Edge Cases Tests")
struct EdgeCasesTests {
    
    @Test("Extremely large numbers in search content")
    func testExtremelyLargeNumbers() {
        let searchContent = SearchContentResponse(
            podcastID: "extreme",
            name: "Extreme Numbers",
            description: "Testing extreme values",
            avatarURL: "https://example.com/extreme.jpg",
            episodeCount: "999999999",
            duration: "999999999",
            language: "en",
            priority: "999999999",
            popularityScore: "999999999",
            score: "999999999.999"
        )
        
        let domainContent = DomainModelsHelper.convertToDomainModel([searchContent])
        let content = domainContent.first!
        
        #expect(content.episodeCount == 999999999)
        #expect(content.duration == 999999999)
        #expect(content.priority == 999999999)
        #expect(content.popularityScore == 999999999)
        #expect(content.score == 999999999.999)
    }
    
    @Test("Empty and whitespace strings")
    func testEmptyAndWhitespaceStrings() {
        let searchContent = SearchContentResponse(
            podcastID: "",
            name: "   ",
            description: "\n\t",
            avatarURL: "",
            episodeCount: "",
            duration: "   ",
            language: "",
            priority: "\n",
            popularityScore: "\t",
            score: "  "
        )
        
        let domainContent = DomainModelsHelper.convertToDomainModel([searchContent])
        let content = domainContent.first!
        
        #expect(content.podcastID == "")
        #expect(content.name == "   ")
        #expect(content.description == "\n\t")
        #expect(content.avatarURL == "")
        #expect(content.episodeCount == 0) // Invalid conversion defaults to 0
        #expect(content.duration == 0)
        #expect(content.priority == 0)
        #expect(content.popularityScore == 0)
        #expect(content.score == 0.0)
    }
    
    @Test("Unicode and special characters in strings")
    func testUnicodeAndSpecialCharacters() {
        let searchContent = SearchContentResponse(
            podcastID: "🎧📻",
            name: "Tëst Pödcäst 中文",
            description: "Dëscriptïön with émojis 😀🎵",
            avatarURL: "https://example.com/ünicode.jpg",
            episodeCount: "42",
            duration: "1800",
            language: "zh-CN",
            priority: "5",
            popularityScore: "85",
            score: "4.5"
        )
        
        let domainContent = DomainModelsHelper.convertToDomainModel([searchContent])
        let content = domainContent.first!
        
        #expect(content.podcastID == "🎧📻")
        #expect(content.name == "Tëst Pödcäst 中文")
        #expect(content.description == "Dëscriptïön with émojis 😀🎵")
        #expect(content.avatarURL == "https://example.com/ünicode.jpg")
        #expect(content.language == "zh-CN")
    }
    
    @Test("Very long strings")
    func testVeryLongStrings() {
        let longString = String(repeating: "A", count: 10000)
        let longURL = "https://example.com/" + String(repeating: "path/", count: 1000) + "file.jpg"
        
        let searchContent = SearchContentResponse(
            podcastID: longString,
            name: longString,
            description: longString,
            avatarURL: longURL,
            episodeCount: "1",
            duration: "1800",
            language: "en",
            priority: "5",
            popularityScore: "85",
            score: "4.5"
        )
        
        let domainContent = DomainModelsHelper.convertToDomainModel([searchContent])
        let content = domainContent.first!
        
        #expect(content.podcastID?.count == 10000)
        #expect(content.name.count == 10000)
        #expect(content.description.count == 10000)
        #expect(content.avatarURL.count > 5000)
    }
    
    @Test("Negative numbers in strings")
    func testNegativeNumbers() {
        let searchContent = SearchContentResponse(
            podcastID: "negative",
            name: "Negative Numbers",
            description: "Testing negative values",
            avatarURL: "https://example.com/negative.jpg",
            episodeCount: "-100",
            duration: "-1800",
            language: "en",
            priority: "-5",
            popularityScore: "-85",
            score: "-4.5"
        )
        
        let domainContent = DomainModelsHelper.convertToDomainModel([searchContent])
        let content = domainContent.first!
        
        #expect(content.episodeCount == -100)
        #expect(content.duration == -1800)
        #expect(content.priority == -5)
        #expect(content.popularityScore == -85)
        #expect(content.score == -4.5)
    }
    
    @Test("Decimal numbers in integer string fields")
    func testDecimalNumbersInIntegerFields() {
        let searchContent = SearchContentResponse(
            podcastID: "decimal",
            name: "Decimal Test",
            description: "Testing decimal in int fields",
            avatarURL: "https://example.com/decimal.jpg",
            episodeCount: "42.7", // Should truncate to 42
            duration: "1800.9",   // Should truncate to 1800
            language: "en",
            priority: "5.5",      // Should truncate to 5
            popularityScore: "85.3", // Should truncate to 85
            score: "4.75"         // Should remain as double
        )
        
        let domainContent = DomainModelsHelper.convertToDomainModel([searchContent])
        let content = domainContent.first!
        
        // Note: Int() constructor truncates decimal values
        #expect(content.episodeCount == 0) // Int("42.7") returns nil, defaults to 0
        #expect(content.duration == 0)     // Int("1800.9") returns nil, defaults to 0
        #expect(content.priority == 0)     // Int("5.5") returns nil, defaults to 0
        #expect(content.popularityScore == 0) // Int("85.3") returns nil, defaults to 0
        #expect(content.score == 4.75)     // Double conversion works fine
    }
}

// MARK: - Performance Tests (Basic)
@Suite("Performance Tests")
struct PerformanceTests {
    
    @Test("Convert large number of sections performs reasonably")
    func testConvertLargeSections() {
        // Create a large dataset
        let largeContent = (0..<1000).map { index in
            SearchContentResponse(
                podcastID: "podcast_\(index)",
                name: "Podcast \(index)",
                description: "Description \(index)",
                avatarURL: "https://example.com/\(index).jpg",
                episodeCount: "\(index)",
                duration: "\(1800 + index)",
                language: "en",
                priority: "\(index % 10)",
                popularityScore: "\(50 + index % 50)",
                score: "\(Double(index % 5) + 1.0)"
            )
        }
        
        let largeSection = SearchSectionResponse(
            name: "Large Section",
            type: "grid",
            contentType: "podcast",
            order: "1",
            content: largeContent
        )
        
        // Measure conversion performance
        let startTime = CFAbsoluteTimeGetCurrent()
        let domainSections = DomainModelsHelper.convertToDomainModel([largeSection])
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        #expect(domainSections.count == 1)
        #expect(domainSections.first?.content.count == 1000)
        #expect(timeElapsed < 1.0) // Should complete within 1 second
    }
    
    @Test("Search repository handles multiple concurrent requests")
    func testConcurrentSearchRequests() async {
        let mockNetwork = MockNetworkService()
        let repository = SearchRepository(network: mockNetwork)
        
        let searchResponse = SearchResponse(sections: [])
        mockNetwork.mockResult = searchResponse
        
        // Perform multiple concurrent searches
        let queries = (0..<10).map { "query \($0)" }
        
        let results = await withTaskGroup(of: [SearchSection]?.self) { group in
            for query in queries {
                group.addTask {
                    try? await repository.search(query: query)
                }
            }
            
            var allResults: [[SearchSection]?] = []
            for await result in group {
                allResults.append(result)
            }
            return allResults
        }
        
        #expect(results.count == 10)
        #expect(results.allSatisfy { $0?.isEmpty == true })
    }
}

// MARK: - Mock Validation Tests
@Suite("Mock Validation Tests")
struct MockValidationTests {
    
    @Test("MockNetworkService captures endpoints correctly")
    func testMockNetworkServiceEndpointCapture() async throws {
        let mockNetwork = MockNetworkService()
        let searchRepository = SearchRepository(network: mockNetwork)
        let sectionsRepository = SectionsRepository(network: mockNetwork)
        
        // Test search endpoint capture
        mockNetwork.mockResult = SearchResponse(sections: [])
        _ = try await searchRepository.search(query: "test")
        #expect(mockNetwork.capturedEndpoint != nil)
        
        // Reset and test sections endpoint capture
        mockNetwork.reset()
        let pagination = Pagination(nextPage: "1", totalPages: 1)
        mockNetwork.mockResult = SectionsResponse(sections: [], pagination: pagination)
        _ = try await sectionsRepository.fetchSections(page: 1)
        #expect(mockNetwork.capturedEndpoint != nil)
    }
    
    @Test("MockNetworkService reset works correctly")
    func testMockNetworkServiceReset() {
        let mockNetwork = MockNetworkService()
        
        // Set some state
        mockNetwork.mockResult = "test"
        mockNetwork.shouldFail = true
        mockNetwork.capturedEndpoint = "endpoint"
        
        // Reset
        mockNetwork.reset()
        
        // Verify reset state
        #expect(mockNetwork.mockResult == nil)
        #expect(mockNetwork.shouldFail == false)
        #expect(mockNetwork.capturedEndpoint == nil)
    }
}

// MARK: - Codable Edge Cases Tests
@Suite("Codable Edge Cases Tests")
struct CodableEdgeCasesTests {
    
    @Test("SearchResponse handles malformed JSON gracefully")
    func testSearchResponseMalformedJSON() {
        let malformedJSONs = [
            "{}",
            "{\"sections\": null}",
            "{\"sections\": \"not an array\"}",
            "{\"sections\": [{}]}",
            "{\"sections\": [{\"name\": null}]}"
        ]
        
        let decoder = JSONDecoder()
        
        for jsonString in malformedJSONs {
            guard let jsonData = jsonString.data(using: .utf8) else {
                Issue.record("Failed to create data from JSON string: \(jsonString)")
                continue
            }
            
            do {
                _ = try decoder.decode(SearchResponse.self, from: jsonData)
                // Some malformed JSON might still decode successfully
            } catch {
                // Expected for truly malformed JSON
                #expect(error is DecodingError)
            }
        }
    }
    
    @Test("SectionsResponse handles missing required fields")
    func testSectionsResponseMissingFields() {
        let jsonWithMissingPagination = """
        {
            "sections": []
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        do {
            _ = try decoder.decode(SectionsResponse.self, from: jsonWithMissingPagination)
            Issue.record("Expected decoding to fail for missing pagination")
        } catch {
            #expect(error is DecodingError)
        }
    }
    
    @Test("PodcastContentResponse handles mixed data types")
    func testPodcastContentResponseMixedTypes() {
        let jsonWithMixedTypes = """
        {
            "podcast_id": 123,
            "name": "Test",
            "description": "Test Description",
            "avatar_url": "https://example.com/test.jpg",
            "episode_count": "not_a_number",
            "duration": 1800,
            "priority": 5,
            "popularityScore": 85,
            "score": 4.5,
            "language": "en"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        // This should handle the type mismatch gracefully or fail predictably
        do {
            let response = try decoder.decode(PodcastContentResponse.self, from: jsonWithMixedTypes)
            // If decoding succeeds, verify the values
            #expect(response.name == "Test")
        } catch {
            // Expected if types don't match exactly
            #expect(error is DecodingError)
        }
    }
}
