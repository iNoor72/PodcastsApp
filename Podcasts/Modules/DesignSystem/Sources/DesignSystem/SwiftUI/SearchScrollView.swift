//
//  SearchScrollView.swift
//  Common
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import Common

public struct SearchScrollView<ScrollContent: View, OnSearchContent: View> : View {
    @Binding var query: String
    var showCancelButton: Bool = false
    var cancelAction: (() -> ())? = nil
    @ViewBuilder var scrollContent: ScrollContent
    @ViewBuilder var onSearchContent: OnSearchContent
    
    public init(
        query: Binding<String>,
        showCancelButton: Bool,
        cancelAction: (() -> Void)? = nil,
        scrollContent: ScrollContent,
        onSearchContent: OnSearchContent
    ) {
        self._query = query
        self.showCancelButton = showCancelButton
        self.cancelAction = cancelAction
        self.scrollContent = scrollContent
        self.onSearchContent = onSearchContent
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            HStack {
                searchBar
                if showCancelButton {
                    cancelButton
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            
            scrollView
        }
    }
}

extension SearchScrollView {
    private var searchBar: some View {
        SearchBarView(query: $query)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            cancelAction?()
        }
        .foregroundStyle(.white)
        .font(CustomFonts.bodyLight)
    }
    
    private var scrollView: some View {
        ScrollView {
            if query.isEmpty {
                scrollContent
            } else {
                onSearchContent
            }
        }
        .scrollIndicators(.hidden)
    }
}
