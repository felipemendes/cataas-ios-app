//
//  ErrorView.swift
//  CATAAS
//
//  Created by Felipe Mendes on 28/05/24.
//

import SwiftUI

struct ErrorView: View {

    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.headline)
                .foregroundStyle(Color.theme.errorColor)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: onRetry) {
                Image(systemName: "arrow.counterclockwise.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.theme.accent, Color.theme.secondaryText)
            }
        }
        .padding()
    }
}

#Preview {
    ErrorView(message: "Error message") { }
}
