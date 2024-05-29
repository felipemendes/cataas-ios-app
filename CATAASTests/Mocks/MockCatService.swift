//
//  MockCatService.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 13/05/24.
//

import Foundation
import Combine
@testable import CATAAS

class MockCatService: CatServiceProtocol {
    var fetchCatsResult: Result<[CatResponse], NetworkingError>?

    func fetchCats(limit: Int, skip: Int) -> AnyPublisher<[CatResponse], NetworkingError> {
        if let result = fetchCatsResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }
}
