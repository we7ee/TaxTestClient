//
//  LoginUser.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 15.10.20.
//

import Foundation

struct LoginUser: TaxEndpointType {
    typealias Response = LoginUserResponse

    private let requestBody: LoginUserRequestBody

    init(username: String, password: String) {
        self.requestBody = LoginUserRequestBody(username: username, password: password)
    }

    var path: String {
        "loginUser"
    }

    var httpMethod: HTTPMethod {
        .POST
    }

    var httpBody: HTTPBody? {
        do {
            let data = try JSONEncoder().encode(requestBody)
            return data
        } catch {
            print("Could no parse LoginUserRequestBody")
            return Data()
        }
    }

    var httpHeaders: HTTPHeaders?

    var urlParameters: URLParameters?
}

struct LoginUserRequestBody: Codable {
    let username: String
    let password: String
}

extension LoginUserRequestBody: Equatable {}

struct LoginUserResponse: Codable {
    let email: String
    let userName: String?
    let userGlobalId: Int
    let error: String
}
