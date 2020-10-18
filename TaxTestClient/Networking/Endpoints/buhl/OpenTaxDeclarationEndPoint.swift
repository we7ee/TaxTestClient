//
//  OpenTaxDeclarationEndPoint.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import Foundation

struct OpenTaxDeclarationEndPoint: TaxEndpointType {
    typealias Response = OpenTaxDeclarationResponse

    private let id: Int

    init(taxDeclaration id: Int) {
        self.id = id
    }

    var path: String {
        "openTaxDeclaration"
    }

    var httpMethod: HTTPMethod {
        .GET
    }

    var httpBody: HTTPBody?

    var httpHeaders: HTTPHeaders?

    var urlParameters: URLParameters? {
        ["id": id]
    }
}
