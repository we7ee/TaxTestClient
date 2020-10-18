//
//  TaxDeclarationResponse.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import Foundation

struct OpenTaxDeclarationResponse: Codable {
    let id: Int
    let year: Int
    let name: String
    let lastUsed: Date
    let session: String
}

extension OpenTaxDeclarationResponse: Equatable {}
