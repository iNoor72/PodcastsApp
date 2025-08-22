//
//  SearchScreen.swift
//  SearchScreen
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI
import Common
import DesignSystem

public struct SearchScreen: View {
    @ObservedObject private var viewModel: SearchScreenViewModel
    
    public init(viewModel: SearchScreenViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            SearchBarView(query: $viewModel.searchQuery)
        }
    }
    
//    @ViewBuilder
//    private var contentView: some View {
//        SearchScrollView(
//            query: $viewModel.searchQuery,
//            showCancelButton: true,
//            scrollContent: {
//                LazyVStack {
//                    ProgressView()
//                }
//            }, onSearchContent: {
//                LazyVStack {
//                    ProgressView()
//                }
//            }
//        )
//    }
}
