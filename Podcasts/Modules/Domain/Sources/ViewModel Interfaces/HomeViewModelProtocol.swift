//
//  HomeViewModelProtocol.swift
//  Domain
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation

public protocol HomeViewModelProtocol {
    var isLoading: Bool { get }
    func fetchPodcasts() async
    @MainActor func fetchMorePodcastsIfNeeded(item: PodcastSection) async
}
