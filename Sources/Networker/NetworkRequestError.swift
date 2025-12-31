//
//  NetworkRequestError.swift
//  Networker
//
//  Created by Scott Nicholes on 12/20/25.
//
import Foundation

public enum NetworkRequestError: LocalizedError, Equatable {
    case invalidRequest
    case invalidResponse
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
}
