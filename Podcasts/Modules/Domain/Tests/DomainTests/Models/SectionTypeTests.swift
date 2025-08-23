//
//  SectionTypeTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//


import Testing
import Foundation
@testable import Domain

struct SectionTypeTests {
    
    @Test func testSectionTypeRawValues() {
        #expect(SectionType.square.rawValue == "square")
        #expect(SectionType.audiobookBigSquare.rawValue == "big_square")
        #expect(SectionType.bigSquare.rawValue == "big square")
        #expect(SectionType.twoLinesGrid.rawValue == "2_lines_grid")
        #expect(SectionType.queue.rawValue == "queue")
    }
    
    @Test func testSectionTypeInitFromRawValue() {
        #expect(SectionType(rawValue: "square") == .square)
        #expect(SectionType(rawValue: "big_square") == .audiobookBigSquare)
        #expect(SectionType(rawValue: "big square") == .bigSquare)
        #expect(SectionType(rawValue: "2_lines_grid") == .twoLinesGrid)
        #expect(SectionType(rawValue: "queue") == .queue)
        #expect(SectionType(rawValue: "invalid") == nil)
    }
    
    @Test func testSectionTypeHashable() {
        let types: Set<SectionType> = [.square, .bigSquare, .queue]
        #expect(types.count == 3)
    }
    
    @Test func testSectionTypeEquality() {
        #expect(SectionType.square == SectionType.square)
        #expect(SectionType.bigSquare != SectionType.square)
    }
}
