//
//  RequestConvertible.swift
//  Networker
//
//  Created by Scott Nicholes on 12/17/25.
//
import Foundation

public protocol RequestConvertible {
    associatedtype Response
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [URLQueryItem]? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    
    func transform(_ data: Data) throws -> Response
}

public extension RequestConvertible {
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    var queryParameters: [URLQueryItem]? { nil }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
}

public extension RequestConvertible where Response == Void {
    func transform(_ data: Data) throws -> Void {
        ()
    }
}

public extension RequestConvertible where Response == Data {
    func transform(_ data: Data) throws -> Data {
        data
    }
}

public extension RequestConvertible where Response: Decodable {
    func transform(_ data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }
}
