//
//  NetworkRequestError.swift
//  Networker
//
//  Created by Scott Nicholes on 12/20/25.
//
import Foundation

public enum NetworkRequestError: LocalizedError, Equatable {
    case badRequest
    case decodingError(_ errorDescription: String?)
    case encodingError(_ errorDescription: String?)
    case error4xx(_ code: Int)
    case error5xx(_ code: Int)
    case forbidden
    case invalidRequest
    case invalidResponse
    case notFound
    case serverError
    case unauthorized
    case unknownError
    case urlSessionFailed(_ error: URLError)
}
