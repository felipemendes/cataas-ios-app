//
//  Endpoint.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Foundation

struct Endpoint {
    
    var path: String
    var queryItems: [URLQueryItem] = []

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = AppConstants.baseURL
        components.path = "/api" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
}
