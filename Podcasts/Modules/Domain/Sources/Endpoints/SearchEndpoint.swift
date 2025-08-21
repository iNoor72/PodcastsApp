//
//  SearchEndpoint.swift
//  Networking
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation
import NetworkLayer

public enum SearchEndpoint: Endpoint {
    case search(query: String)
    
    public var base: String {
        return APIConstants.getBundleInfo(for: APIKeys.searchPodcastsBaseURL)
    }
    
    public var path: String {
        switch self {
        case .search(query: let query):
            return "/search"
        }
    }
    
    public var queryItems: [String: String]? {
        return [:]
    }
    
    public var method: String {
        return "GET"
    }

}
