//
//  EndPointTests.swift
//  TaxTestClientTests
//
//  Created by Willy Breitenbach on 16.10.20.
//

import XCTest
@testable import TaxTestClient

class EndPointTests: XCTestCase {

    private let baseURL = "https://steuerwebprelive.buhl.de/demoservice/rest"

    // MARK: - LoginUser

    func test_makeRequest_LoginUser_urlIsCorrect() {
        // Given
        let loginUser = LoginUserEndPoint(email: "name", password: "password")

        // When
        let request = loginUser.makeRequest()

        // Then
        XCTAssertEqual(request?.url?.absoluteString, "\(baseURL)/loginUser")
    }

    func test_makeRequest_LoginUser_httBodyIsCorrect() {
        // Given
        let username = "name"
        let password = "password"
        let loginUser = LoginUserEndPoint(email: username, password: password)
        let userLoginBody = LoginUserRequestBody(email: username, password: password)
        let expectedBodyData = try! JSONEncoder().encode(userLoginBody)

        // When
        let request = loginUser.makeRequest()

        // Then
        XCTAssertEqual(request?.httpBody, expectedBodyData)
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Content-Type"], "application/json")
    }

    func test_makeRequest_urlEndcoding_isWorkingCorrectly() {
        // Given
        let id = 1

        let openTaxDeclarationEndPoint = OpenTaxDeclarationEndPoint(taxDeclaration: id)

        let exptectedURL = baseURL + "/openTaxDeclaration?id=1"

        // When
        let request = openTaxDeclarationEndPoint.makeRequest()

        // Then

        XCTAssertEqual(request?.url?.absoluteString, exptectedURL)
    }
}
