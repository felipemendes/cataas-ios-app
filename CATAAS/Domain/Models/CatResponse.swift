//
//  CatResponse.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Foundation

struct CatResponse: Codable, Identifiable {
    let id: String
    let mimetype: String
    let size: Int
    let tags: [String]

    var imageUrl: URL {
        URL(string: "https://\(AppConstants.baseURL)/cat/\(id)")!
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case mimetype
        case size
        case tags
    }
}

extension CatResponse: Hashable {
    static func == (lhs: CatResponse, rhs: CatResponse) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CatResponse {
    static func fake() -> Self {
        CatResponse(id: "7zbLgQ7kbUAM4xxB", mimetype: "image/jpeg", size: 1234, tags: ["cute", "pose", "paw"])
    }
}
