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
        return "https://" + APIConstants.getBundleInfo(for: APIKeys.searchPodcastsBaseURL)
    }
    
    public var path: String {
        switch self {
        case .search:
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
