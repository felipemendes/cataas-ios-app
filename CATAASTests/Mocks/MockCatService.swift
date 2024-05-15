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
    var fetchCatsResult: Result<[CatResponse], Error>?

    func fetchCats(limit: Int, skip: Int) -> AnyPublisher<[CatResponse], Error> {
        if let result = fetchCatsResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }
}
