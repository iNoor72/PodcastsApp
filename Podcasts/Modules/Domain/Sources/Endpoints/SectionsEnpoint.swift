//
//  SectionsEnpoint.swift
//  Networking
//
//  Created by Noor El-Din Walid on 19/08/2025.
//

import Foundation
import NetworkLayer

public enum SectionsEnpoint: Endpoint {
    case fetchSections(page: Int)
    
    public var base: String {
        return "https://" + APIConstants.getBundleInfo(for: APIKeys.fetchPodcastsBaseURL)
    }
    
    public var path: String {
        switch self {
        case .fetchSections:
            return "/home_sections"
        }
    }
    
    public var queryItems: [String: String]? {
        switch self {
            case .fetchSections(let page):
            return ["page": page.description]
        }
    }
    
    public var method: String {
        return "GET"
    }
}
