//
//  GridCard.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import SwiftUI
import Domain

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
