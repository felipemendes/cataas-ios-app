//
//  CatsService.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Combine
import Foundation

final class CatService: CatServiceProtocol {

    private let repository: CatRepositoryProtocol

    init(repository: CatRepositoryProtocol = CatRepository()) {
        self.repository = repository
    }

    func fetchCats(limit: Int = 10, skip: Int = 0) -> AnyPublisher<[CatResponse], NetworkingError> {
        repository.getCats(limit: limit, skip: skip)
            .mapError { error in
                guard let urlError = error as? URLError else {
                    return NetworkingError.unknown
                }

                return NetworkingError.badURLResponse(
                    url: urlError.failingURL ?? URL(string: "https://\(AppConstants.baseURL)/api/cats")!
                )
            }
            .eraseToAnyPublisher()
    }
}
