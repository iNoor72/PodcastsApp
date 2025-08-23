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
        VStack {
            HStack {
                Spacer()
                Text("Home")
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    viewModel.searchButtonTapped()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                }
            }
            
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.sections, id: \.id) { section in
                        HomeContentSection(section: section, isRTL: isRTL)
                            .onAppear {
                                Task {
                                    await viewModel.fetchMorePodcastsIfNeeded(item: section)
                                }
                            }
                    }
                }
                .padding(.vertical, 20)
            }
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
            .onAppear {
                Task {
                    await viewModel.fetchPodcasts()
                }
            }
        }
        .background(Color.black)
    }
}

// MARK: - Main Section Component
struct HomeContentSection: View {
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
