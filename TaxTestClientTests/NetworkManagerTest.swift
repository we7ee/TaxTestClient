//
//  NetworkManagerTest.swift
//  TaxTestClientTests
//
//  Created by Willy Breitenbach on 16.10.20.
//

import XCTest
@testable import TaxTestClient

class NetworkManagerTest: XCTestCase {

    var sut: NetworkManager!
    var urlSessionMock: URLSessionMock!

    override func setUpWithError() throws {
        urlSessionMock = URLSessionMock()
        sut = NetworkManager(urlSession: urlSessionMock)
    }

    func test_request_serverError() throws {
        // Given
        let userLoginEndpoint = LoginUser(username: "name", password: "password")

        let error = URLSessionMock.MockError.anyError

        urlSessionMock.mockDataTaskResponse(nil, nil, error)

        // When
        sut.request(for: userLoginEndpoint) { (result) in
            switch result {
                case .failure(let error):
                XCTAssertEqual(error, .offline)
                case .success(_):
                XCTFail("Test should not be successful")
            }
        }
    }

    func test_request_responseWithNoData() throws {
        // Given
        let userLoginEndpoint = LoginUser(username: "name", password: "password")
        let url = userLoginEndpoint.makeRequest()!.url!

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        urlSessionMock.mockDataTaskResponse(nil, response, nil)

        // When
        sut.request(for: userLoginEndpoint) { (result) in
            switch result {
                case .failure(let error):
                XCTAssertEqual(error, .serverError)
                case .success(_):
                XCTFail("Test should not be successful")
            }
        }
    }

    func test_request_responseWithData() throws {
        // Given
        let userLoginEndpoint = LoginUser(username: "name", password: "password")
        let url = userLoginEndpoint.makeRequest()!.url!

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = """
        {
            "email": "test@test.de",
            "error": "ok",
            "userGlobalId": 12345,
            "userName": "Testi Tester"
        }
        """.data(using: .utf8)

        urlSessionMock.mockDataTaskResponse(data, response, nil)

        // When
        sut.request(for: userLoginEndpoint) { (result) in
            switch result {
                case .failure(_):
                    XCTFail("Test should be successful")
                case .success(let userResponse):
                    XCTAssertEqual(userResponse.email, "test@test.de")
                    XCTAssertEqual(userResponse.error, "ok")
                    XCTAssertEqual(userResponse.userGlobalId, 12345)
                    XCTAssertEqual(userResponse.userName, "Testi Tester")
            }
        }
    }

    func test_request_responseWithBadRequest() throws {
        // Given
        let userLoginEndpoint = LoginUser(username: "name", password: "password")
        let url = userLoginEndpoint.makeRequest()!.url!

        let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)

        urlSessionMock.mockDataTaskResponse(nil, response, nil)

        // When
        sut.request(for: userLoginEndpoint) { (result) in
            switch result {
                case .failure(let error):
                XCTAssertEqual(error, .serverError)
                case .success(_):
                XCTFail("Test should not be successful")
            }
        }
    }

}

class URLSessionMock: URLSession {
    private var mockResponse: URLResponse?
    private var mockError: Error?
    private var mockData: Data?

    enum MockError: Error {
        case anyError
    }

    override init() {}

    func mockDataTaskResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTaskMock = URLSessionDataTaskMock(
            mockData,
            mockResponse,
            mockError,
            completionHandler: completionHandler
        )

        return dataTaskMock
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    var mockResponse: URLResponse?
    var mockError: Error?
    var mockData: Data?

    let handler: (Data?, URLResponse?, Error?) -> Void

    init(_ data: Data?, _ response: URLResponse?, _ error: Error?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
        self.handler = completionHandler
    }

    override func resume() {
        handler(mockData, mockResponse, mockError)
    }
}
