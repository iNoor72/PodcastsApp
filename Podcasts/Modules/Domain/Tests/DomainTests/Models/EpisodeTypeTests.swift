//
//  EpisodeTypeTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Testing
import Foundation
@testable import Domain

struct EpisodeTypeTests {
  
  @Test func testEpisodeTypeRawValues() {
      #expect(EpisodeType.full.rawValue == "full")
      #expect(EpisodeType.trailer.rawValue == "trailer")
  }
  
  @Test func testEpisodeTypeInitFromRawValue() {
      #expect(EpisodeType(rawValue: "full") == .full)
      #expect(EpisodeType(rawValue: "trailer") == .trailer)
      #expect(EpisodeType(rawValue: "invalid") == nil)
  }
  
  @Test func testEpisodeTypeEquality() {
      #expect(EpisodeType.full == EpisodeType.full)
      #expect(EpisodeType.trailer == EpisodeType.trailer)
      #expect(EpisodeType.full != EpisodeType.trailer)
  }
  
  @Test func testEpisodeTypeSendable() {
      let episodeType: EpisodeType = .full
      
      Task {
          let taskEpisodeType = episodeType
          #expect(taskEpisodeType == .full)
      }
  }
  
  @Test func testEpisodeTypeAllCases() {
      let allTypes: [EpisodeType] = [.full, .trailer]
      
      #expect(allTypes.count == 2)
      #expect(allTypes.contains(.full))
      #expect(allTypes.contains(.trailer))
  }
  
  @Test func testEpisodeTypeRawValueCaseSensitivity() {
      #expect(EpisodeType(rawValue: "FULL") == nil)
      #expect(EpisodeType(rawValue: "Full") == nil)
      #expect(EpisodeType(rawValue: "TRAILER") == nil)
      #expect(EpisodeType(rawValue: "Trailer") == nil)
  }
}
