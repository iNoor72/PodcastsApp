//
//  CacheAsyncImage.swift
//  Common
//
//  Created by Noor El-Din Walid on 21/08/2025.
//

import SwiftUI

public struct CacheAsyncImage<Content>: View where Content: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    private let contentMode: ContentMode
    @State private var trialsCounter = 5

    public init(
        urlString: String,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        contentMode: ContentMode = .fit,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = URL(string: urlString)
        self.scale = scale
        self.transaction = transaction
        self.contentMode = contentMode
        self.content = content
    }

    public var body: some View {

        if let url = url, let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                if trialsCounter <= 0 {
                    Image(AppConstants.imagePlaceholderName)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .cornerRadius(8.0)
                } else {
                    cacheAndRender(phase: phase)
                }
            }.onReceive(timer) { _ in
                if trialsCounter > 0 {
                    trialsCounter -= 1
                } else {
                    timer.upstream.connect().cancel()
                }
            }
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            guard let url else { return content(phase) }
            ImageCache[url] = image
        }

        return content(phase)
    }
}


@MainActor
fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            //Cache 30 images at max, for the app not to grow quickly on memory
            if cache.count > 30 {
                _ = cache.popFirst()
            }
            ImageCache.cache[url] = newValue
        }
    }
}
