//
//  NetworkManager.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 16.10.20.
//

import Foundation

protocol NetworkManaging {

}

enum NetworkError: Error {
    case offline
    case serverError
    case unableToDecode
}

enum NetworkResponseError: Error {
    case authenticationError
    case badRequest
    case failed
}

typealias NetworkResult<T: EndPointType> = (Result<T.Response, NetworkError>) -> ()

class NetworkManager: NetworkManaging {

    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func request<T: EndPointType>(for endpoint: T, completion: @escaping NetworkResult<T>) {
        guard let request = endpoint.makeRequest() else {
            // return network error -> invalid endpoint
            return
        }

        let task = urlSession.dataTask(with: request) { (responseData, urlResponse, responseError) in
            if let _ = responseError {
                completion(.failure(.offline))
                return
            }

            if let response = urlResponse {
                if let responseError = self.handleNetworkResponse(response) {
                    print("Received network response error: \(responseError)")
                    completion(.failure(.serverError))
                } else {
                    guard let data = responseData else {
                        print("Received no data")
                        completion(.failure(.serverError))
                        return
                    }

                    do {
                        let object = try JSONDecoder().decode(T.Response.self, from: data)
                        completion(.success(object))
                    } catch let decodingError {
                        print("An error occured while decoding response: \(decodingError)")
                        completion(.failure(.unableToDecode))
                    }
                }
            } else {
                print("Recieved no valid response")
                completion(.failure(.serverError))
            }
        }

        task.resume()
    }

    private func handleNetworkResponse(_ response: URLResponse) -> NetworkResponseError? {

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failed
        }

        switch httpResponse.statusCode {
            case 200...299: return nil
            case 400: return .badRequest
            case 401...403: return .authenticationError
            default: return .failed
        }
    }
}


