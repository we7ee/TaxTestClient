//
//  NetworkManagerMock.swift
//  TaxTestClientTests
//
//  Created by Willy Breitenbach on 17.10.20.
//

import XCTest
@testable import TaxTestClient

class NetworkManagerMock<T: EndPointType>: NetworkManaging {

    var networkResultMock: (Result<T.Response, NetworkError>)? = nil

    func mockNetworkResulst(_ networkResult: Result<T.Response, NetworkError>) {
        self.networkResultMock = networkResult
    }

    func request<T>(for endpoint: T, completion: @escaping NetworkResult<T>) where T : EndPointType {
        switch networkResultMock {
            case .failure(let error):
                completion(.failure(error))
            case .success(let object):
                let s = object as! T.Response
                completion(.success(s))
            case .none:
                XCTFail("Network result must have and result type")
        }
    }
}
