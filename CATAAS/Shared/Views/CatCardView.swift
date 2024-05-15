//
//  CatCardView.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

struct CatCardView: View {

    let cat: CatResponse
    private let cornerRadius: CGFloat = 10

    var body: some View {
        VStack {
            CatImage(cat: cat)

            if !cat.tags.isEmpty {
                TagsView(cat: cat, font: .subheadline, lineLimit: 1)
                    .padding([.horizontal, .bottom])
            }
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.theme.secondaryBackground)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CatCardView(cat: CatResponse.fake())
}
