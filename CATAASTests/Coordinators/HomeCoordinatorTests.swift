//
//  HomeCoordinatorTests.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 14/05/24.
//

import XCTest
import SwiftUI
import Combine

@testable import CATAAS

class HomeCoordinatorTests: XCTestCase {

    var sut: HomeCoordinator!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        sut = HomeCoordinator()
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    func testShowDetail() {
        // Given
        let cat = CatResponse.fake()

        // When
        sut.showDetail(with: cat)

        // Then
        XCTAssertEqual(sut.selectedCat, cat)
    }
}
