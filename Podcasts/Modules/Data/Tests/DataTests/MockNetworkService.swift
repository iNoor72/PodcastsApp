//
//  MockNetworkService.swift
//  Data
//
//  Created by Noor El-Din Walid on 24/08/2025.
//

import Testing
import Foundation
@testable import Data
@testable import Domain
@testable import NetworkLayer

// MARK: - Mock Network Service
final class MockNetworkService: NetworkServiceProtocol {
    func request<T>(with endpoint: any NetworkLayer.Endpoint, completion: @escaping (Result<T, NetworkLayer.NetworkError>) -> Void) where T : Decodable {
        capturedEndpoint = endpoint
        
        if shouldFail {
            completion(.failure(.unknown))
        }
        
        guard let result = mockResult as? T else {
            completion(.failure(.decodingError))
        }
        
        completion(.success(result))
    }
    
    var mockResult: Any?
    var shouldFail = false
    var capturedEndpoint: Any?
    
    func request<T>(with endpoint: any Endpoint) async -> Result<T, NetworkError> where T : Decodable {
        capturedEndpoint = endpoint
        
        if shouldFail {
            return .failure(.unknown)
        }
        
        guard let result = mockResult as? T else {
            return .failure(.decodingError)
        }
        
        return .success(result)
    }
    
    func reset() {
        mockResult = nil
        shouldFail = false
        capturedEndpoint = nil
    }
}
