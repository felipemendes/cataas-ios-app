//
//  AsyncImage+Cache.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI
import Combine

struct CachedAsyncImage<Content: View>: View {

    @StateObject private var loader: ImageLoader
    private let content: (Image) -> Content

    init(url: URL, imageName: String, @ViewBuilder content: @escaping (Image) -> Content) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, imageName: imageName))
        self.content = content
    }

    var body: some View {
        contentBuilder()
            .onAppear(perform: loader.fetchImage)
    }

    @ViewBuilder
    private func contentBuilder() -> some View {
        if loader.isLoading {
            ProgressView()
        } else if let error = loader.error {
            Text(error.localizedDescription)
                .foregroundStyle(Color.theme.errorColor)
        } else if let image = loader.image {
            content(Image(uiImage: image))
        } else {
            Text("No Image Available")
        }
    }
}
