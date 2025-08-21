//
//  SearchScrollView.swift
//  Common
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI

public struct SearchScrollView<ScrollContent: View, OnSearchContent: View> : View {
    @Binding var query: String
    var showCancelButton: Bool = false
    var cancelAction: (() -> ())? = nil
    @ViewBuilder var scrollContent: ScrollContent
    @ViewBuilder var onSearchContent: OnSearchContent
    
    public var body: some View {
        VStack(spacing: 24) {
            HStack {
                searchBar
                if showCancelButton {
                    cancelButton
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            
            scrollView
        }
    }
}

extension SearchScrollView {
    private var searchBar: some View {
        SearchBarView(query: $query)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            cancelAction?()
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            if query.isEmpty {
                scrollContent
            } else {
                onSearchContent
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct PodcastCard: View {
    var body: some View {
        VStack {
            CacheAsyncImage(urlString: "", content: { phase in
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
            .frame(height: 250)
            
            HStack {
                PlayButton(duration: "30 mins")
                Text("Yesterday")
            }
        }
    }
}

struct GridCard: View {
    var body: some View {
        HStack {
            CacheAsyncImage(urlString: "", content: { phase in
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
            
            VStack {
                Text("")
                Text("")
                HStack {
                    PlayButton(duration: "30 mins")
                    Spacer()
                    Button("Options") {
                        
                    }
                    
                    Button("Add to playlist") {
                        
                    }
                }
            }
        }
    }
}

struct SquareCard: View {
    var body: some View {
    }
}

struct BigSquareCard: View {
    var body: some View {
    }
}

struct PlayButton: View {
    let duration: String
    let playIcon: String
    let isRTL: Bool
    let textColor: Color
    let backgroundColor: Color
    let overlayColor: Color
    
    init(
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
    
    var body: some View {
        HStack(spacing: 6) {
            if !isRTL {
                Image(systemName: playIcon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textColor)
            }
            
            Text(duration)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textColor)
            
            if isRTL {
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
