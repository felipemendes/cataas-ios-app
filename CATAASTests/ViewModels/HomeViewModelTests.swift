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
    var mockAppLogger: MockLogger!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockCatService()
        mockAppLogger = MockLogger()
        sut = HomeViewModel(catService: mockService, appLogger: mockAppLogger)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockAppLogger = nil
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

    func testFetchCatsFailure_badURLResponse() {
        // Given
        let error = NetworkingError.badURLResponse(url: URL(string: "mock_url")!)
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
        XCTAssertEqual(sut.errorMessage, "Oops! We received an unexpected error. Please check your internet connection and try again later")
        XCTAssertFalse(sut.isLoading)
    }
    
    func testFetchCatsFailure_statusCodeError() {
        // Given
        let error = NetworkingError.statusCodeError(code: 1, url: URL(string: "mock_url")!)
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
        XCTAssertEqual(sut.errorMessage, "We're sorry, but we encountered an issue while trying to access the data. Please check your internet connection and try again later")
        XCTAssertFalse(sut.isLoading)
    }

    func testFetchCatsFailure_unknown() {
        // Given
        let error = NetworkingError.unknown
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
        XCTAssertEqual(sut.errorMessage, "An unexpected error occurred. Please check your internet connection and try again later.")
        XCTAssertFalse(sut.isLoading)
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
