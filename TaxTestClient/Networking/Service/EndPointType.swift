//
//  EndPointType.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 15.10.20.
//

import Foundation
import os.log

typealias HTTPBody = Data
typealias URLParameters = [String: Any]
typealias HTTPHeaders = [String: String]

protocol EndPointType {
    associatedtype Response: Codable
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpBody: HTTPBody? { get }
    var httpHeaders: HTTPHeaders? { get }
    var urlParameters: URLParameters? { get }
}

extension EndPointType {
    func makeRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "\(baseURL.path)/\(path)"

        if let parameters = urlParameters {
            for (key, value) in parameters {
                let query = URLQueryItem(
                    name: key,
                    value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                )

                components.queryItems?.append(query)
            }
        }

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)

        if let httpBody = httpBody {
            request.httpBody = httpBody
        }

        return request
    }
}
