//
//  CatRepository.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Combine

protocol CatRepositoryProtocol {
    func getCats(limit: Int, skip: Int) -> AnyPublisher<[CatResponse], Error>
}

final class CatRepository: CatRepositoryProtocol {
    func getCats(limit: Int, skip: Int) -> AnyPublisher<[CatResponse], Error> {
        CatAPI.fetchCats(limit: limit, skip: skip)
    }
}
