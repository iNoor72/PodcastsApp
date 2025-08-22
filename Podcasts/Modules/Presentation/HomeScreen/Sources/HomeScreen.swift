// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Common
import Domain

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
                HorizontalCardList(items: section.content, isRTL: isRTL)
            case .bigSquare:
                HorizontalCardList(items: section.content, isRTL: isRTL)
            case .audiobookBigSquare:
                HorizontalCardList(items: section.content, isRTL: isRTL)
            case .queue:
                HorizontalCardList(items: section.content, isRTL: isRTL)
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
    let items: [PodcastContent]
    let isRTL: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [
                GridItem(.flexible(minimum: 200), spacing: 8),
                GridItem(.flexible(minimum: 200), spacing: 8)
            ], spacing: 4) {
                ForEach(items, id: \.id) { item in
                    GridCard(podcast: item)
                        .padding(.horizontal, 16)
                }
            }
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

public struct PodcastCard: View {
    private let podcast: PodcastContent
    public init(podcast: PodcastContent) {
        self.podcast = podcast
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            CacheAsyncImage(urlString: podcast.avatarURL, contentMode: .fit, content: { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .foregroundStyle(.white)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8.0)
                    
                    //Including error state
                default:
                    Image(AppConstants.imagePlaceholderName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8.0)
                }
            })
            .frame(height: 100)
            
            Text(podcast.name)
                .frame(maxWidth: 100)
                .lineLimit(0)
                .truncationMode(.tail)
                .foregroundStyle(.white)
            
            HStack {
                PlayButton(duration: podcast.duration.secondsToHoursAndMinutes())
                Text(DateFormatterHelper.formatDate(podcast.releaseDate))
                    .foregroundStyle(.white)
            }
        }
    }
}

public struct GridCard: View {
    private let podcast: PodcastContent
    public init(podcast: PodcastContent) {
        self.podcast = podcast
    }
    
    public var body: some View {
        HStack {
            CacheAsyncImage(urlString: podcast.avatarURL, content: { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .foregroundStyle(.white)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8.0)
                    
                    //Including error state
                default:
                    Image(AppConstants.imagePlaceholderName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8.0)
                }
            })
            
            VStack(alignment: .leading) {
                Text("Released \(DateFormatterHelper.formatDate(podcast.releaseDate))")
                    .foregroundStyle(.white)
                
                Text(podcast.name)
                    .foregroundStyle(.white)
                
                Spacer()
                
                HStack {
                    PlayButton(duration: podcast.duration.secondsToHoursAndMinutes())
                    Spacer()
                    Button("Options") {
                        
                    }
                    
                    Button("Add to playlist") {
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
//        .padding(.horizontal, 16)
        
    }
}

public struct SquareCard: View {
    public var body: some View {
    }
}

public struct BigSquareCard: View {
    public var body: some View {
    }
}

public struct PlayButton: View {
    let duration: String
    let playIcon: String
    let isRTL: Bool
    let textColor: Color
    let backgroundColor: Color
    let overlayColor: Color
    
    public init(
        duration: String,
        playIcon: String = "play.fill",
        isRTL: Bool = false,
        textColor: Color = .white,
        backgroundColor: Color = Color.gray.opacity(0.8),
        overlayColor: Color = Color.black.opacity(0.4)
    ) {
        self.duration = duration
        self.playIcon = playIcon
        self.isRTL = isRTL
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.overlayColor = overlayColor
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            if !isRTL {
                Image(systemName: playIcon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textColor)
                
                Spacer()
            }
            
            Text(duration)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textColor)
            
            if isRTL {
                Spacer()
                
                Image(systemName: playIcon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textColor)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(backgroundColor)
        )
        .overlay(
            Capsule()
                .stroke(overlayColor, lineWidth: 1)
        )
        .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
    }
}
