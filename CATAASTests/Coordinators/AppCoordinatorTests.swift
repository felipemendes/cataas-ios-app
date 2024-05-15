//
//  AppCoordinatorTests.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 14/05/24.
//

import XCTest
@testable import CATAAS

class AppCoordinatorTests: XCTestCase {
    var sut: AppCoordinator!

    override func setUp() {
        super.setUp()
        sut = AppCoordinator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testStart() {
        // Given
        let newCoordinator = AppCoordinator()

        // When
        newCoordinator.start()

        // Then
        XCTAssertNotNil(newCoordinator.homeCoordinator)
    }
}
