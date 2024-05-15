//
//  CATAASTests.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 14/05/24.
//

import XCTest
import Combine
@testable import CATAAS

class HomeViewModelTests: XCTestCase {

    var sut: HomeViewModel!
    var mockService: MockCatService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockCatService()
        sut = HomeViewModel(catService: mockService)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchCatsSuccess() {
        // Given
        let cats = [CatResponse(id: "1", mimetype: "image/jpeg", size: 12345, tags: ["cute"]),
                    CatResponse(id: "2", mimetype: "image/jpeg", size: 67890, tags: ["funny"])]
        mockService.fetchCatsResult = .success(cats)

        // When
        let expectation = XCTestExpectation(description: "Fetch cats successfully")

        sut.$cats.dropFirst().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)

        sut.fetchCats()

        // Then
        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(sut.cats, cats)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testFetchCatsFailure() {
        // Given
        let error = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "The operation couldn’t be completed. (Test error 1.)"])
        mockService.fetchCatsResult = .failure(error)

        // When
        let expectation = XCTestExpectation(description: "Fetch cats failure")

        sut.$errorMessage.dropFirst().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)

        sut.fetchCats()

        // Then
        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(sut.cats, [])
        XCTAssertEqual(sut.errorMessage, "The operation couldn’t be completed. (Test error 1.)")
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.hasMoreData)
    }

    func testFetchCatsNoMoreData() {
        // Given
        let cats = [CatResponse(id: "1", mimetype: "image/jpeg", size: 12345, tags: ["cute"])]
        mockService.fetchCatsResult = .success(cats)

        // When
        let expectation = XCTestExpectation(description: "Fetch cats no more data")

        sut.$hasMoreData.dropFirst().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)

        sut.fetchCats()

        // Then
        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(sut.cats, cats)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.hasMoreData)
    }
}
