//
//  SearchScrollView.swift
//  Common
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI

public struct SearchScrollView<ScrollContent: View, OnSearchContent: View> : View {
    @Binding var query: String
    var showCancelButton: Bool = false
    var cancelAction: (() -> ())? = nil
    @ViewBuilder var scrollContent: ScrollContent
    @ViewBuilder var onSearchContent: OnSearchContent
    
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
