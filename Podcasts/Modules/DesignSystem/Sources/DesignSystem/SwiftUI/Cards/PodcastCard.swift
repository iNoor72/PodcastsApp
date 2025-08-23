//
//  PodcastCard.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import SwiftUI
import Domain
import Common

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
                .font(CustomFonts.title3)
                .frame(maxWidth: 150)
                .foregroundStyle(.white)
            
            HStack {
                PlayButton(duration: podcast.duration.secondsToHoursAndMinutes())
            }
        }
    }
}
