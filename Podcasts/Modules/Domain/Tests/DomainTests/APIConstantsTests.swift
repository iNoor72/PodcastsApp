//
//  APIConstantsTests.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//


import Testing
import Foundation
@testable import Domain

struct APIConstantsTests {
  
  @Test func testGetBundleInfoWithValidKey() {
      let result = APIConstants.getBundleInfo(for: "CFBundleName")
      #expect(!result.isEmpty)
  }
  
  @Test func testGetBundleInfoWithInvalidKey() {
      let result = APIConstants.getBundleInfo(for: "INVALID_KEY_THAT_DOES_NOT_EXIST")
      #expect(result.isEmpty)
  }
  
  @Test func testGetBundleInfoWithEmptyKey() {
      let result = APIConstants.getBundleInfo(for: "")
      #expect(result.isEmpty)
  }
  
  @Test func testGetBundleInfoReturnType() {
      let result = APIConstants.getBundleInfo(for: "CFBundleName")
      #expect(result is String)
  }
  
  @Test func testGetBundleInfoConsistency() {
      let result1 = APIConstants.getBundleInfo(for: "CFBundleName")
      let result2 = APIConstants.getBundleInfo(for: "CFBundleName")
      #expect(result1 == result2)
  }
}
