//
//  DetailViewModel.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Foundation

final class DetailViewModel: ObservableObject {

    // MARK: - Initializer

    init(cat: CatResponse) {
        self.cat = cat
    }

    // MARK: - Public API

    @Published var cat: CatResponse
}
