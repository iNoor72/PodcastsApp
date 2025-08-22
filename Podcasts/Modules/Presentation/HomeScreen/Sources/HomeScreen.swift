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

public struct PodcastCard: View {
    private let podcast: PodcastContent
    public init(podcast: PodcastContent) {
        self.podcast = podcast
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
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
            .frame(height: UIScreen.main.bounds.width * 0.4)
            
            Text(podcast.name)
                .frame(maxWidth: 150)
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
                Text(podcast.name)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Spacer()
                
                HStack {
                    PlayButton(duration: podcast.duration.secondsToHoursAndMinutes())
                    Spacer()
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                    
                    Image(systemName: "text.badge.plus")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(height: 75)
    }
}

public struct BigSquareCard: View {
    private let podcast: PodcastContent
    public init(podcast: PodcastContent) {
        self.podcast = podcast
    }
    
    public var body: some View {
        CacheAsyncImage(urlString: podcast.avatarURL, content: { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .foregroundStyle(.white)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        VStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(podcast.podcastName ?? podcast.name)
                                    .foregroundStyle(.white)
                                    .bold()
                                    .lineLimit(1)
                                
                                Text(podcast.duration.secondsToHoursAndMinutes())
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                            .blurBackground()
                        }
                    }
                    .cornerRadius(8.0)
                
                //Including error state
            default:
                Image(AppConstants.imagePlaceholderName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8.0)
            }
        })
        .frame(height: UIScreen.main.bounds.width * 0.8)
    }
}

public struct QueueCard: View {
    private let podcast: PodcastContent
    
    public init(podcast: PodcastContent) {
        self.podcast = podcast
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            ZStack {
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
                .frame(width: 110, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.leading, 16)
            .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(podcast.duration.secondsToHoursAndMinutes())
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    
                    Text("•")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    
                    Text(String(podcast.episodeCount ?? 0) + " episodes")
                        .foregroundColor(.orange)
                        .font(.system(size: 12, weight: .medium))
                }
                
                Text(podcast.name)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(podcast.description)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .padding(.vertical, 16)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image(systemName: "play.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                        .background {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 30, height: 30)
                        }
                }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 32)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
        )
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
