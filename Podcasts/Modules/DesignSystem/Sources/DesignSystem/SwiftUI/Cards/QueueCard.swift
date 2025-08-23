//
//  QueueCard.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import SwiftUI
import Domain
import Common

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
                        .font(CustomFonts.footnote)
                        .lineLimit(1)
                    
                    Text("•")
                        .foregroundColor(.gray)
                        .font(CustomFonts.footnote)
                    
                    Text(String(podcast.episodeCount ?? 0) + " episodes")
                        .foregroundColor(.orange)
                        .font(CustomFonts.footnote)
                        .lineLimit(1)
                }
                
                Text(podcast.name)
                    .foregroundColor(.white)
                    .font(CustomFonts.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 16)
            .frame(maxWidth: UIScreen.main.bounds.width - 16, alignment: .leading)
            
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
        .frame(maxWidth: UIScreen.main.bounds.width - 32, alignment: .leading)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
        )
    }
}
