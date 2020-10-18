//
//  TaxDeclarationEndPoint.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 17.10.20.
//

import Foundation

struct TaxDeclarationEndPoint: TaxEndpointType {
    typealias Response = [TaxDeclarationResponse]

    var path: String {
        "taxDeclarations"
    }

    var httpMethod: HTTPMethod {
        .GET
    }

    var httpBody: HTTPBody?

    var httpHeaders: HTTPHeaders?

    var urlParameters: URLParameters?
}
