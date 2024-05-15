//
//  CatAPI.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Combine
import Foundation

enum CatAPI {

    // MARK: - Public API

    static func fetchCats(limit: Int = 10, skip: Int = 0) -> AnyPublisher<[CatResponse], Error> {
        let endpoint = Endpoint(path: "/cats", queryItems: [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)")
        ])

        return URLSession.shared.dataTaskPublisher(for: endpoint.url)
            .tryMap { result in
                try handleHTTPResponse(result)
            }
            .decode(type: [CatResponse].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    // MARK: - Private

    private static func handleHTTPResponse(_ result: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = result.response as? HTTPURLResponse else {
            throw NetworkingError.badURLResponse(url: result.response.url!)
        }
        switch response.statusCode {
        case 200...299:
            return result.data
        case 400...499:
            throw NetworkingError.statusCodeError(code: response.statusCode, url: result.response.url!)
        case 500...599:
            throw NetworkingError.statusCodeError(code: response.statusCode, url: result.response.url!)
        default:
            throw NetworkingError.unknown
        }
    }
}
