//
//  CatServiceProtocol.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Combine

protocol CatServiceProtocol {
    func fetchCats(limit: Int, skip: Int) -> AnyPublisher<[CatResponse], Error>
}
