//
//  TaxDeclarationTests.swift
//  TaxTestClientTests
//
//  Created by Willy Breitenbach on 18.10.20.
//

import XCTest
@testable import TaxTestClient

class TaxDeclarationTests: XCTestCase {

    var sut: TaxDeclarationController!

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_onSuccess_TaxDeclarationSectionIsCreated() throws {
        // Given
        let networkManagerMock = NetworkManagerMock<TaxDeclarationEndPoint>()
        sut = TaxDeclarationController(networkManager: networkManagerMock)

        let taxDeclarationResponse = [
            TaxDeclarationResponse(id: 1, year: 2019, name: "Steuer 2019", lastUsed: Date()),
            TaxDeclarationResponse(id: 2, year: 2020, name: "Steuer 2020", lastUsed: Date()),
            TaxDeclarationResponse(id: 3, year: 2020, name: "Neue Steuer 2020", lastUsed: Date())
        ]

        networkManagerMock.mockNetworkResulst(.success(taxDeclarationResponse))

        // Then
        sut.didReceiveState = { state in
            switch state {
                case .success(let dataSource):
                    let firstItem = dataSource.item(for: IndexPath(row: 0, section: 0))
                    let secondItem = dataSource.item(for: IndexPath(row: 0, section: 1))
                    let thirdItem = dataSource.item(for: IndexPath(row: 1, section: 1))

                    XCTAssertEqual(firstItem.id, taxDeclarationResponse[0].id)
                    XCTAssertEqual(secondItem.id, taxDeclarationResponse[1].id)
                    XCTAssertEqual(thirdItem.id, taxDeclarationResponse[2].id)

                default:
                    XCTFail("This state should be successful")
            }
        }

        // When
        sut.getTaxDeclarations()
    }
}
