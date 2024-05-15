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
    let lineLimit: Int

    var body: some View {
        Text(tagsText)
            .font(font)
            .foregroundStyle(Color.theme.secondaryText)
            .lineLimit(lineLimit)
            .truncationMode(.tail)
    }

    private var tagsText: String {
        cat.tags.map { "#\($0)" }.joined(separator: " ")
    }
}

#Preview {
    TagsView(cat: CatResponse.fake(), font: .headline, lineLimit: 2)
}
