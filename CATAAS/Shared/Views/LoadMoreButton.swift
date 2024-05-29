//
//  LoadMoreButton.swift
//  CATAAS
//
//  Created by Felipe Mendes on 28/05/24.
//

import SwiftUI

struct LoadMoreButton: View {
    
    var body: some View {
        HStack {
            Image(systemName: "arrowshape.down.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.theme.accent, Color.theme.secondaryText)
            Text("Load More")
        }
        .foregroundColor(Color.theme.accent)
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color.theme.secondaryBackground)
        .cornerRadius(10)
        .shadow(
            color: .black.opacity(0.4),
            radius: 5,
            x: 0,
            y: 5)
    }
}

#Preview {
    LoadMoreButton()
}

