//
//  TaxDeclarationsResponse.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 17.10.20.
//

import Foundation

struct TaxDeclarationResponse: Codable {
    let id: Int
    let year: Int
    let name: String
    let lastUsed: Date
}

extension TaxDeclarationResponse: Equatable {}
