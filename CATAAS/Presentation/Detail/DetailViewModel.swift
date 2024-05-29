//
//  DetailViewModel.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Foundation

final class DetailViewModel: ObservableObject {

    @Published var cat: CatResponse
    
    init(cat: CatResponse) {
        self.cat = cat
    }
}
