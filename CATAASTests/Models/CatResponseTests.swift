//
//  CatResponseTests.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 14/05/24.
//

import XCTest
@testable import CATAAS

class CatResponseTests: XCTestCase {

    func testDecoding() {
        // Given

        let json = """
        {
            "_id": "7zbLgQ7kbUAM4xxB",
            "mimetype": "image/jpeg",
            "size": 1234,
            "tags": ["cute", "pose", "paw"]
        }
        """.data(using: .utf8)!

        // When
        let decoder = JSONDecoder()
        let catResponse = try! decoder.decode(CatResponse.self, from: json)

        // Then
        XCTAssertEqual(catResponse.id, "7zbLgQ7kbUAM4xxB")
        XCTAssertEqual(catResponse.mimetype, "image/jpeg")
        XCTAssertEqual(catResponse.size, 1234)
        XCTAssertEqual(catResponse.tags, ["cute", "pose", "paw"])
    }

    func testImageUrlGeneration() {
        // Given
        let catResponse = CatResponse.fake()

        // When
        let imageUrl = catResponse.imageUrl

        // Then
        XCTAssertEqual(imageUrl.absoluteString, "https://cataas.com/cat/7zbLgQ7kbUAM4xxB")
    }

    func testHashableConformance() {
        // Given
        let cat1 = CatResponse.fake()
        let cat2 = CatResponse.fake()
        var set = Set<CatResponse>()

        // When
        set.insert(cat1)
        set.insert(cat2)

        // Then
        XCTAssertEqual(set.count, 1)
    }

    func testEquatableConformance() {
        // Given
        let cat1 = CatResponse.fake()
        let cat2 = CatResponse.fake()

        // Then
        XCTAssertEqual(cat1, cat2)
    }
}
