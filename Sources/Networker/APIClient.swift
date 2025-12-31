//
//  NetworkDispatcher.swift
//  
//
//  Created by Scott Nicholes on 1/7/22.
//

import Foundation
import Combine

public struct APIClient {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension APIClient: Dispatcher {
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    func dispatch<T>(request: URLRequest, transform: @escaping (Data) throws -> T) -> AnyPublisher<T, NetworkRequestError> {
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw httpErrorFromStatusCode(response.statusCode)
                }
                return try transform(data)
            }
            .mapError { error in
                handleError(error)
            }
            .eraseToAnyPublisher()
    }
}

extension APIClient {
    private func httpErrorFromStatusCode(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError: return .decodingError
        case let urlError as URLError: return .urlSessionFailed(urlError)
        case let error as NetworkRequestError: return error
        default: return .unknownError
        }
    }
}
