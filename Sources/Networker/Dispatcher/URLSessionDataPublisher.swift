//
//  URLSessionDataPublisher.swift
//  Networker
//
//  Created by Scott Nicholes on 12/31/25.
//
import Foundation
import Combine

final class URLSessionDataPublisher: DataTaskPublisher {
    @available(iOS 13.0, *)
    func execute(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), NetworkRequestError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let validResponse = response as? HTTPURLResponse else {
                    throw NetworkRequestError.invalidResponse
                }
                
                guard (200...299).contains(validResponse.statusCode) else {
                    throw self.httpErrorFromStatusCode(validResponse.statusCode)
                }
                
                return (data, validResponse)
            }
            .mapError { error in
                self.handleError(error)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, *)
extension URLSessionDataPublisher {
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
