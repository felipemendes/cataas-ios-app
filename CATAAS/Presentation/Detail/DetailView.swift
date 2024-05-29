//
//  DetailView.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        VStack(alignment: .leading) {
            TagsView(
                cat: viewModel.cat, 
                font: .headline)
            
            CatImage(cat: viewModel.cat)
                .padding(.bottom)

            Text("ID reference: \(viewModel.cat.id)")
                .font(.callout)
                .foregroundStyle(.gray)
        }
        .navigationBarTitle("Cat Details")
        .padding()
    }
}

#Preview {
    DetailView(viewModel: DetailViewModel(cat: CatResponse.fake()))
}
