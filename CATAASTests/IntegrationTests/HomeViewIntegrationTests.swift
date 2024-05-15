//
//  HomeViewIntegrationTests.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 14/05/24.
//

import XCTest
import SwiftUI
import Combine

@testable import CATAAS

class HomeViewIntegrationTests: XCTestCase {

    var mockService: MockCatService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockCatService()
        cancellables = []
    }

    override func tearDown() {
        mockService = nil
        cancellables = nil
        super.tearDown()
    }

    func testHomeViewDisplaysCats() {
        // Given
        mockService.fetchCatsResult = .success([
            CatResponse(id: "1", mimetype: "image/jpeg", size: 12345, tags: ["cute"]),
            CatResponse(id: "2", mimetype: "image/jpeg", size: 67890, tags: ["funny"])
        ])

        let homeViewModel = HomeViewModel(catService: mockService)

        let expectation = XCTestExpectation(description: "Fetch and display cats")

        // Create HomeView
        let homeView = HomeView(viewModel: homeViewModel)

        // When
        homeViewModel.fetchCats()

        // Then
        homeViewModel.$cats.dropFirst().sink { cats in
            XCTAssertEqual(cats.count, 2)
            XCTAssertEqual(cats[0].id, "1")
            XCTAssertEqual(cats[1].id, "2")
            expectation.fulfill()
        }.store(in: &cancellables)

        // Simulate HomeView
        let view = UIHostingController(rootView: homeView)
        XCTAssertNotNil(view.view)

        wait(for: [expectation], timeout: 1.0)
    }
}
