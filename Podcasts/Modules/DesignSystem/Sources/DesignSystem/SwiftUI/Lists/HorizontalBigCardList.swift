//
//  HorizontalBigCardList.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import SwiftUI
import Domain

public struct HorizontalBigCardList: View {
    let items: [PodcastContent]
    let isRTL: Bool
    
    public init(items: [PodcastContent], isRTL: Bool) {
        self.items = items
        self.isRTL = isRTL
    }
    
    public var body: some View {
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
