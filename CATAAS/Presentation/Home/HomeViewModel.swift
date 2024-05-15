//
//  HomeViewModel.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    // MARK: - Initializer

    init(catService: CatServiceProtocol = CatService()) {
        self.catService = catService
    }

    // MARK: - Public API

    @Published var cats: [CatResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var hasMoreData: Bool = true

    func fetchCats() {
        guard !isLoading && hasMoreData else {
            return
        }

        isLoading = true

        catService.fetchCats(limit: pageSize, skip: currentPage * pageSize)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }

                self.isLoading = false
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.hasMoreData = false
                }
            }, receiveValue: { [weak self] newCats in
                self?.update(newCats)
            })
            .store(in: &cancellables)
    }

    // MARK: - Private
    
    private let catService: CatServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0
    private let pageSize: Int = 10

    private func update(_ newCats: [CatResponse]) {
        cats.append(contentsOf: newCats)
        currentPage += 1
        hasMoreData = newCats.count == self.pageSize
    }
}
