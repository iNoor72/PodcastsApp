//
//  HorizontalGridCardList.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import SwiftUI
import Domain

public struct HorizontalGridCardList: View {
    private let rowItems = [
        GridItem(.flexible(minimum: 100), spacing: 16),
        GridItem(.flexible(minimum: 100), spacing: 16)
    ]
    
    let items: [PodcastContent]
    let isRTL: Bool
    
    public init(items: [PodcastContent], isRTL: Bool) {
        self.items = items
        self.isRTL = isRTL
    }
    
    public var body: some View {
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
