//
//  LoginUserResponse.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 17.10.20.
//

import Foundation

struct LoginUserResponse: Equatable, Codable {
    let email: String
    let userName: String?
    let userGlobalId: Int
    let error: String
}
