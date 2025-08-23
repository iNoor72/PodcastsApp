// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Common
import Domain
import DesignSystem

public struct HomeScreen: View {
    @ObservedObject private var viewModel: HomeScreenViewModel
    private let isRTL = Locale.current.language.languageCode?.identifier == "ar"
    
    public init(viewModel: HomeScreenViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                ForEach(viewModel.sections, id: \.id) { section in
                    ContentSection(section: section, isRTL: isRTL)
                        .onAppear {
                            Task {
                                await viewModel.fetchMorePodcastsIfNeeded(item: section)
                            }
                        }
                    
                    if section != viewModel.sections.last {
                        Divider()
                            .frame(height: 0.5)
                            .background(.white)
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color.black)
        .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
        .onAppear {
            Task {
                await viewModel.fetchPodcasts()
            }
        }
    }
}

// MARK: - Main Section Component
struct ContentSection: View {
    let section: PodcastSection
    let isRTL: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionNavigationHeaderView(title: section.name, showBackButton: true, languageDirection: isRTL ? .rightToLeft : .leftToRight)
            
            switch section.type {
            case .square:
                HorizontalCardList(items: section.content, isRTL: isRTL)
            case .bigSquare, .audiobookBigSquare:
                HorizontalBigCardList(items: section.content, isRTL: isRTL)
            case .queue:
                HorizontalQueueList(items: section.content, isRTL: isRTL)
            case .twoLinesGrid:
                HorizontalGridCardList(items: section.content, isRTL: isRTL)
            }
        }
        .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
    }
}
