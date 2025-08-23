//
//  RetryView.swift
//  DesignSystem
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import SwiftUI
import Common

public struct RetryView: View {
    var errorMessage: String
    var action: () -> Void
    var dismissAction: (() -> ())?
    
    public init(errorMessage: String, action: @escaping () -> Void, dismissAction: (() -> Void)? = nil) {
        self.errorMessage = errorMessage
        self.action = action
        self.dismissAction = dismissAction
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Spacer()
            imageView
            textView
            browseButton(title: "Refresh", action: action)
            Spacer()
        }
    }
}

extension RetryView {
    private var imageView: some View {
        Image(systemName: "arrow.circlepath")
            .resizable()
            .frame(maxWidth: 200, maxHeight: 200)
            .foregroundStyle(.white)
    }
    
    private var textView: some View {
        VStack(alignment: .center, spacing: 8) {
            title
            subTitle
        }
        .padding(.horizontal, 16)
    }
}

extension RetryView {
    private var title: some View {
        Text("Failed to Load")
            .font(CustomFonts.title2)
            .foregroundStyle(.white)
    }
    
    private var subTitle: some View {
        Text("An error has occurred. Error: \(errorMessage) \nYou can try again by refreshing this page")
            .font(CustomFonts.title3)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
    }
    
    private func browseButton(title: LocalizedStringKey, action : @escaping () -> Void) -> some View {
        Button() {
            action()
        } label: {
            HStack{
                Text(title)
                    .font(CustomFonts.buttonText)
                    .foregroundStyle(.white)
                
                Image(systemName: "arrow.circlepath")
            }
        }
    }
}
