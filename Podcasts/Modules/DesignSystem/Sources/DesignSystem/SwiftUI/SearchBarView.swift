//
//  SearchBarView.swift
//  Common
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI

public struct SearchBarView: View {
    @Binding var query: String
    
    public init(query: Binding<String>) {
        self._query = query
    }
    
    private enum Constants {
        static let searchBarIcon = "magnifyingglass"
        static let contentSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let borderLineWidth: CGFloat = 1
    }
    
    public var body: some View {
        HStack(spacing: Constants.contentSpacing) {
            searchIcon
            searchTextField
        }
        .padding(8)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(.white, lineWidth: Constants.borderLineWidth)
        )
    }
    
    private var searchIcon: some View {
        Image(systemName: Constants.searchBarIcon)
            .foregroundStyle(.white)
    }
    
    private var searchTextField: some View {
        TextField(
            "",
            text: $query,
            prompt: Text("Search ...").foregroundColor(.init(white: 1, opacity: 0.4))
        )
        .foregroundStyle(.white)
    }
}
