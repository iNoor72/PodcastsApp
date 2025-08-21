// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Common
import Domain

public struct HomeScreen: View {
    @ObservedObject private var viewModel: HomeScreenViewModel
    
    let isRTL = Locale.current.language.languageCode?.identifier == "ar"
    
    public init(viewModel: HomeScreenViewModel) {
        self.viewModel = viewModel
    }
        
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                ForEach(viewModel.sections, id: \.id) { section in
                    ContentSection(section: section, isRTL: isRTL)
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color.black)
        .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
        .task {[weak viewModel] in
            await viewModel?.fetchPodcasts()
        }
    }
}

// MARK: - Main Section Component
struct ContentSection: View {
    let section: PodcastSection
    let isRTL: Bool
    
    var body: some View {
        VStack(alignment: isRTL ? .trailing : .leading, spacing: 16) {
            SectionNavigationHeaderView(title: section.name, showBackButton: true, languageDirection: isRTL ? .rightToLeft : .leftToRight)
            
            switch section.type {
            case .square:
                HorizontalCardRow(items: section.content, isRTL: isRTL)
            case .bigSquare:
                VerticalCardList(items: section.content, isRTL: isRTL)
            case .audiobookBigSquare:
                VerticalCardList(items: section.content, isRTL: isRTL)
            case .queue:
                VerticalCardList(items: section.content, isRTL: isRTL)
            case .twoLinesGrid:
                VerticalCardList(items: section.content, isRTL: isRTL)
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

struct HorizontalCardRow: View {
    let items: [PodcastContent]
    let isRTL: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(items, id: \.id) { item in
                    
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct VerticalCardList: View {
    let items: [PodcastContent]
    let isRTL: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items, id: \.id) { item in
                
            }
        }
        .padding(.horizontal, 20)
    }
}
