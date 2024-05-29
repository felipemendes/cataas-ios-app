//
//  HomeViewModel.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    @Published var cats: [CatResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var hasMoreData: Bool = true

    private let appLogger: LoggerProtocol
    private let catService: CatServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0
    private let pageSize: Int = 10

    init(
        catService: CatServiceProtocol,
        appLogger: LoggerProtocol
    ) {
        self.catService = catService
        self.appLogger = appLogger
    }

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
                    self.errorMessage = error.friendlyLocalizedDescription
                    appLogger.error(error.errorDescription)
                }
            }, receiveValue: { [weak self] newCats in
                self?.updateResponse(with: newCats)
            })
            .store(in: &cancellables)
    }

    private func updateResponse(with newCats: [CatResponse]) {
        cats.append(contentsOf: newCats)
        currentPage += 1
        hasMoreData = newCats.count == self.pageSize
    }
}
