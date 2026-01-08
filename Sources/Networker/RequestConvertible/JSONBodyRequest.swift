//
//  JSONBodyRequest.swift
//  Networker
//
//  Created by Scott Nicholes on 1/6/26.
//
import Foundation

public protocol JSONBodyRequest: RequestConvertible, BodyProviding {
    associatedtype Body: Encodable
    var body: Body { get }
}

public extension JSONBodyRequest {
    var contentType: String {
        "application/json"
    }
    
    func encodeBody() throws -> Data {
        try JSONEncoder().encode(body)
    }
    
    var headers: [String: String] {
        var headers = self.headers
        headers["Content-Type"] = self.contentType
        return headers
    }
}
