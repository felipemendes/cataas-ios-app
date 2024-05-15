//
//  CatAPITests.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 14/05/24.
//

import XCTest
import Combine
@testable import CATAAS

class CatAPITests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        cancellables = nil
        super.tearDown()
    }

    func testFetchCatsSuccess() {
        // Given
        let cats = [
            CatResponse(id: "1", mimetype: "image/jpeg", size: 12345, tags: ["cute"]),
            CatResponse(id: "2", mimetype: "image/jpeg", size: 67890, tags: ["funny"])
        ]
        let data = try! JSONEncoder().encode(cats)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let expectation = XCTestExpectation(description: "Fetch cats")

        // When
        CatAPI.fetchCats()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, got error: \(error)")
                }
            }, receiveValue: { fetchedCats in
                // Then
                XCTAssertEqual(fetchedCats, cats)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchCatsFailure() {
        // Given
        let errorResponse = """
        {
            "error": "Bad request"
        }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, errorResponse)
        }

        let expectation = XCTestExpectation(description: "Fetch cats failure")

        // When
        CatAPI.fetchCats()
            .sink(receiveCompletion: { completion in
                // Then
                if case let .failure(error) = completion {
                    XCTAssertEqual(error.localizedDescription, NetworkingError.statusCodeError(code: 400, url: URL(string: "https://cataas.com/api/cats?limit=10&skip=0")!).localizedDescription)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
