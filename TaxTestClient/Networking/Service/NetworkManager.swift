//
//  NetworkManager.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 16.10.20.
//

import Foundation

typealias NetworkResult<T: EndPointType> = (Result<T.Response, NetworkError>) -> Void

protocol NetworkManaging {
    func request<T: EndPointType>(for endpoint: T, completion: @escaping NetworkResult<T>)
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

class NetworkManager: NetworkManaging {

    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func request<T: EndPointType>(for endpoint: T, completion: @escaping NetworkResult<T>) {
        guard let request = endpoint.makeRequest() else {
            fatalError("Unable to create request")
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
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601WihtoutTimeZone)
                        let object = try jsonDecoder.decode(T.Response.self, from: data)

                        self.saveUserSession(response)

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

    private func saveUserSession(_ response: URLResponse) {
        guard let httpUrlResponse = response as? HTTPURLResponse,
              let restState = httpUrlResponse.allHeaderFields["restState"] as? String else {
            return
        }

        PersitenceHelper.restState = restState
    }
}


