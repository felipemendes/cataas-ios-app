//
//  NetworkingError.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import Foundation

enum NetworkingError: LocalizedError {

    case badURLResponse(url: URL)
    case statusCodeError(code: Int, url: URL)
    case unknown

    var errorDescription: String {
        switch self {
        case let .badURLResponse(url): return "Bad response from URL: \(url)"
        case let .statusCodeError(code, url): return "Received HTTP \(code) from URL: \(url)"
        case .unknown: return "Unknown error occurred"
        }
    }

    var friendlyLocalizedDescription: String {
        switch self {
        case .badURLResponse: return "Oops! We received an unexpected error. Please check your internet connection and try again later"
        case .statusCodeError: return "We're sorry, but we encountered an issue while trying to access the data. Please check your internet connection and try again later"
        case .unknown: return "An unexpected error occurred. Please check your internet connection and try again later."
        }
    }
}
