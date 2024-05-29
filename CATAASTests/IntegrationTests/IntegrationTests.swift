//
//  IntegrationTests.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 14/05/24.
//

import XCTest
import Combine
@testable import CATAAS

class IntegrationTests: XCTestCase {

    var mockService: MockCatService!
    var mockAppLogger: MockLogger!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockCatService()
        mockAppLogger = MockLogger()
        cancellables = []
    }

    override func tearDown() {
        mockService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchingAndDisplayingCats() {
        // Given
        mockService.fetchCatsResult = .success([
            CatResponse(id: "1", mimetype: "image/jpeg", size: 12345, tags: ["cute"]),
            CatResponse(id: "2", mimetype: "image/jpeg", size: 67890, tags: ["funny"])
        ])

        let homeViewModel = HomeViewModel(catService: mockService, appLogger: mockAppLogger)
        let expectation = XCTestExpectation(description: "Fetch and display cats")

        // When
        homeViewModel.fetchCats()

        // Then
        homeViewModel.$cats.dropFirst().sink { cats in
            XCTAssertEqual(cats.count, 2)
            XCTAssertEqual(cats[0].id, "1")
            XCTAssertEqual(cats[1].id, "2")
            expectation.fulfill()
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
