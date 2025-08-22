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
        VStack(alignment: .leading, spacing: 16) {
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

struct SectionHeader: View {
    let title: String
    let isRTL: Bool
    let showMore: Bool
    
    var body: some View {
        HStack {
            if showMore {
                Button(action: {}) {
                    Image(systemName: isRTL ? "chevron.right" : "chevron.left")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
            
            Spacer()
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(isRTL ? .trailing : .leading)
            
            if !showMore {
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}

struct HorizontalGridCardList: View {
    private let rowItems = [
        GridItem(.flexible(minimum: 100), spacing: 16),
        GridItem(.flexible(minimum: 100), spacing: 16)
    ]
    
    let items: [PodcastContent]
    let isRTL: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rowItems, spacing: 16) {
                ForEach(items, id: \.id) { item in
                    GridCard(podcast: item)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HorizontalCardList: View {
    let items: [PodcastContent]
    let isRTL: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(items, id: \.id) { item in
                    PodcastCard(podcast: item)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HorizontalBigCardList: View {
    let items: [PodcastContent]
    let isRTL: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(items, id: \.id) { item in
                    BigSquareCard(podcast: item)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HorizontalQueueList: View {
    let items: [PodcastContent]
    let isRTL: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(items, id: \.id) { item in
                    QueueCard(podcast: item)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
