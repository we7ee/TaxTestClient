//
//  URLSessionMock.swift
//  TaxTestClientTests
//
//  Created by Willy Breitenbach on 17.10.20.
//

import Foundation

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
