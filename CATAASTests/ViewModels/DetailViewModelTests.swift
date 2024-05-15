//
//  File.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 14/05/24.
//

import XCTest
@testable import CATAAS

class DetailViewModelTests: XCTestCase {

    var sut: DetailViewModel!
    var catFake = CatResponse.fake()

    override func setUp() {
        super.setUp()
        sut = DetailViewModel(cat: catFake)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInitialization() {
        // Given
        let expectedCat = catFake

        // When
        let cat = sut.cat

        // Then
        XCTAssertEqual(cat.id, expectedCat.id)
        XCTAssertEqual(cat.mimetype, expectedCat.mimetype)
        XCTAssertEqual(cat.size, expectedCat.size)
        XCTAssertEqual(cat.tags, expectedCat.tags)
    }

    func testCatPropertyUpdate() {
        // Given
        let newCat = CatResponse(
            id: "2",
            mimetype: "image/png",
            size: 67890,
            tags: ["adorable", "sleepy"]
        )

        // When
        sut.cat = newCat

        // Then
        XCTAssertEqual(sut.cat.id, newCat.id)
        XCTAssertEqual(sut.cat.mimetype, newCat.mimetype)
        XCTAssertEqual(sut.cat.size, newCat.size)
        XCTAssertEqual(sut.cat.tags, newCat.tags)
    }
}
