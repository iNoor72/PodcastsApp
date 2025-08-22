//
//  BigSquareCard.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import SwiftUI
import Domain

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
