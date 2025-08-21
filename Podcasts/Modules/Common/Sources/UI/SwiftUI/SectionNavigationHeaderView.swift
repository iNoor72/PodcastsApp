//
//  SectionNavigationHeaderView.swift
//  Common
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import UIKit
import SwiftUI

public struct SectionNavigationHeaderView: UIViewRepresentable {
    let title: String
    let showBackButton: Bool
    let languageDirection: SectionNavigationHeader.LanguageDirection
    let onBackTapped: (() -> Void)?
    
    public init(title: String,
                showBackButton: Bool = true,
                languageDirection: SectionNavigationHeader.LanguageDirection = .leftToRight,
                onBackTapped: (() -> Void)? = nil) {
        self.title = title
        self.showBackButton = showBackButton
        self.languageDirection = languageDirection
        self.onBackTapped = onBackTapped
    }
    
    public func makeUIView(context: Context) -> SectionNavigationHeader {
        let header = SectionNavigationHeader(title: title,
                                           showBackButton: showBackButton,
                                           languageDirection: languageDirection)
        header.onBackTapped = onBackTapped
        return header
    }
    
    public func updateUIView(_ uiView: SectionNavigationHeader, context: Context) {
        uiView.title = title
        uiView.showBackButton = showBackButton
        uiView.languageDirection = languageDirection
        uiView.onBackTapped = onBackTapped
    }
}
