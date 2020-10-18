//
//  LoginControllerTests.swift
//  TaxTestClientTests
//
//  Created by Willy Breitenbach on 17.10.20.
//

import XCTest
@testable import TaxTestClient

class LoginControllerTests: XCTestCase {

    var sut: LoginController!

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_loginController_invalidInput() throws {
        // Setup
        let networkManagerMock = NetworkManagerMock<LoginUserEndPoint>()
        sut = LoginController(networkManager: networkManagerMock)

        sut.didReceiveState = { state in
            // Then
            XCTAssertEqual(state, LoginState.failed(.invalidInput(message: "Your input is not valid. Please enter valid email and password")))
        }

        // When
        sut.login(with: nil, and: nil)
        sut.login(with: nil, and: "")
        sut.login(with: nil, and: "a")
        sut.login(with: "", and: nil)
        sut.login(with: "a", and: nil)
    }

    func test_loginController_wrongEmailPassword() throws {
        // Setup
        let networkManagerMock = NetworkManagerMock<LoginUserEndPoint>()
        sut = LoginController(networkManager: networkManagerMock)

        let loginUserResponse = LoginUserResponse(email: "email", userName: nil, userGlobalId: 0, error: "notvalid")

        networkManagerMock.mockNetworkResulst(.success(loginUserResponse))

        sut.didReceiveState = { state in
            // Then
            XCTAssertEqual(state, LoginState.failed(.wrongEmailPassword(message: "Wrong email or password. Please try again")))
        }

        // When
        sut.login(with: "email", and: "password")
    }

    func test_loginController_success() throws {
        // Setup
        let networkManagerMock = NetworkManagerMock<LoginUserEndPoint>()
        sut = LoginController(networkManager: networkManagerMock)

        let loginUserResponse = LoginUserResponse(email: "email", userName: "username", userGlobalId: 0, error: "ok")

        networkManagerMock.mockNetworkResulst(.success(loginUserResponse))

        sut.didReceiveState = { state in
            // Then
            XCTAssertEqual(state, .success(username: "username"))
        }

        // When
        sut.login(with: "email", and: "password")
    }

    // Add more test for all edge cases
}
