//
//  SearchScreen.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import Common
import DesignSystem
import Domain

public struct SearchScreen: View {
    @ObservedObject private var viewModel: SearchScreenViewModel
    private let isRTL = Locale.current.language.languageCode?.identifier == "ar"
    
    public init(viewModel: SearchScreenViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        contentView
            .background(.black)
            .onChange(of: viewModel.debounceValue) { query in
                Task {
                    await viewModel.searchPodcasts(with: query)
                }
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        SearchScrollView(
            query: $viewModel.searchQuery,
            showCancelButton: true,
            cancelAction: {
                viewModel.searchQuery = ""
                viewModel.sections.removeAll()
            },
            scrollContent: scrollContent,
            onSearchContent: onSearchContent
        )
    }
    
    private var scrollContent: some View {
        LazyVStack(spacing: 16) {
            if !viewModel.searchQuery.isEmpty {
                ProgressView("Loading search results for \(viewModel.searchQuery)")
            } else {
                Text("Type something to search...")
            }
        }
        .foregroundStyle(.white)
    }
    
    @ViewBuilder
    private var onSearchContent: some View {
        LazyVStack {
            if viewModel.sections.isEmpty {
                Text("No search results for \(viewModel.searchQuery)")
                    .foregroundStyle(.white)
            } else {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.sections, id: \.id) { section in
                        ContentSection(section: section, isRTL: isRTL)
                    }
                }
                .padding(.top, 16)
            }
        }
    }
}

struct ContentSection: View {
    let section: SearchSection
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
