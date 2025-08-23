//
//  GridCard.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import SwiftUI
import Domain
import Common

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
                    .font(CustomFonts.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Spacer()
                
                HStack {
                    PlayButton(duration: podcast.duration.secondsToHoursAndMinutes())
                        .frame(width: UIScreen.main.bounds.width * 0.35)
                    Spacer()
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                    
                    Image(systemName: "text.badge.plus")
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
            }
        }
        .frame(height: 75)
    }
}
