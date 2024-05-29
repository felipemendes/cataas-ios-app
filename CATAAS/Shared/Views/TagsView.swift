//
//  TagsView.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

struct TagsView: View {

    let cat: CatResponse
    let font: Font
    private let hSpacing: CGFloat = 8

    var body: some View {
        HStack(spacing: hSpacing) {
            Image(systemName: "tag.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.theme.accent, Color.theme.secondaryText)

            Text(tagsText)
                .font(font)
                .foregroundStyle(Color.theme.secondaryText)
                .truncationMode(.tail)
        }
    }

    private var tagsText: String {
        cat.tags.map { "#\($0)" }.joined(separator: " ")
    }
}

#Preview {
    TagsView(cat: CatResponse.fake(), font: .headline)
}
