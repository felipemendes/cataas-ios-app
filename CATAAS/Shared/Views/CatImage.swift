//
//  CatImage.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

struct CatImage: View {

    let cat: CatResponse
    private let cornerRadius: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            CachedAsyncImage(url: cat.imageUrl, imageName: cat.id) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .cornerRadius(cornerRadius)
                    .clipped()
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CatImage(cat: CatResponse.fake())
}
