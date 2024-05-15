//
//  HomeView.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var coordinator: HomeCoordinator
    @State private var hasLoaded: Bool = false
    private let gridSpacing: CGFloat = 20

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading && viewModel.cats.isEmpty {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage, viewModel.cats.isEmpty {
                    errorView(with: errorMessage)
                } else {
                    contentView
                }
            }
            .navigationBarTitle("Cats")
        }
        .onAppear {
            if !hasLoaded {
                viewModel.fetchCats()
                hasLoaded = true
            }
        }
    }
}

extension HomeView {
    private var contentView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: gridSpacing) {
                ForEach(viewModel.cats) { cat in
                    Button(action: { [weak coordinator] in
                        coordinator?.showDetail(with: cat)
                    }) {
                        CatCardView(cat: cat)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(
                        NavigationLink(
                            destination: coordinator.makeDetailView(),
                            tag: cat,
                            selection: $coordinator.selectedCat, label: {
                                EmptyView()
                            }
                        )
                    )
                }

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.hasMoreData {
                    Color.clear
                        .onAppear { [weak viewModel] in
                            viewModel?.fetchCats()
                        }
                }
            }
            .padding()
        }
    }

    private func errorView(with errorMessage: String) -> some View {
        Text(errorMessage)
            .foregroundStyle(Color.theme.errorColor)
            .padding()
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
        .environmentObject(HomeCoordinator())
}
