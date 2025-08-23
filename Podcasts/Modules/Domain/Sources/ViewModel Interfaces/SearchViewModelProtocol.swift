//
//  SearchViewModelProtocol.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation

public protocol SearchViewModelProtocol {
    var isLoading: Bool { get }
    var searchQuery: String { get }
    var debounceValue: String { get }
    func searchPodcasts(with query: String) async
}
