//
//  HomeCoordinator.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

final class HomeCoordinator: ObservableObject {

    // MARK: - Public API

    @Published var homeViewModel: HomeViewModel?
    @Published var selectedCat: CatResponse?

    func start(catService: CatServiceProtocol) -> some View {
        HomeView(viewModel: homeViewModel ?? HomeViewModel(catService: catService))
            .environmentObject(self)
    }

    func showDetail(with cat: CatResponse) {
        selectedCat = cat
    }

    @ViewBuilder
    func makeDetailView() -> some View {
        if let selectedCat = selectedCat {
            DetailView(viewModel: DetailViewModel(cat: selectedCat))
        }
    }
}
