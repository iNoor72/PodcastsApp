//
//  View+Extensions.swift
//  Common
//
//  Created by Noor El-Din Walid on 22/08/2025.
//


import SwiftUI

public extension View {
    func blurBackground(style: ColorScheme = .dark) -> some View {
        modifier(BlurBackground(style: style))
    }
}

fileprivate struct BlurBackground: ViewModifier {
    let style: ColorScheme
    
    func body(content: Content) -> some View {
        content
            .background {
                Color.clear
                    .background(.ultraThinMaterial)
                    .environment(\.colorScheme, style)
            }
    }
}
