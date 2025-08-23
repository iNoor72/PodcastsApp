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
        ZStack {
            switch viewModel.viewState {
            case .initial:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(.white)
                    .onAppear {
                        Task {
                            await viewModel.fetchPodcasts()
                        }
                    }
                
            case .error(let errorMessage):
                RetryView(errorMessage: errorMessage) {
                    viewModel.viewState = .initial
                    
                    Task {
                        await viewModel.fetchPodcasts()
                    }
                }
                .background(.black)
                
            default:
                contentView
            }
        }
        .background(Color.black)
    }
    
    private var contentView: some View {
        ZStack {
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
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
            
            if viewModel.isLoading {
                ProgressView()
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
