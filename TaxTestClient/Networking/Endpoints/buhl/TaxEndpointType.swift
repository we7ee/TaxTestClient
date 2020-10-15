//
//  TaxEndpointType.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 15.10.20.
//

import Foundation

protocol TaxEndpointType: EndPointType {}

extension TaxEndpointType {
    var baseURL: URL {
        let urlString = "https://steuerwebprelive.buhl.de/demoservice/rest"

        guard let url = URL(string: urlString) else {
            fatalError("URL string is not a valid url.")
        }

        return url
    }
}
