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
        ZStack {
            switch viewModel.viewState {
            case .error(let errorMessage):
                RetryView(errorMessage: errorMessage) {
                    viewModel.viewState = .initial
                    
                    Task {
                        await viewModel.searchPodcasts(with: viewModel.searchQuery)
                    }
                }
                
            default:
                contentView
                    .onChange(of: viewModel.debounceValue) { query in
                        Task {
                            await viewModel.searchPodcasts(with: query)
                        }
                    }
            }
        }
        .background(.black)
    }
    
    @ViewBuilder
    private var contentView: some View {
        ZStack {
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
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
    
    private var scrollContent: some View {
        LazyVStack(spacing: 16) {
            if viewModel.searchQuery.isEmpty {
                Text("Type something to search...")
                    .font(CustomFonts.bodyLight)
            }
        }
        .foregroundStyle(.white)
    }
    
    @ViewBuilder
    private var onSearchContent: some View {
        LazyVStack(spacing: 32) {
            ForEach(viewModel.sections, id: \.id) { section in
                ContentSection(section: section, isRTL: isRTL)
            }
        }
        .padding(.top, 16)
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
