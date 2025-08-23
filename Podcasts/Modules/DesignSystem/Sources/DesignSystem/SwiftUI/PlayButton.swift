//
//  PlayButton.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import SwiftUI
import Common

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
                .font(CustomFonts.callout)
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
