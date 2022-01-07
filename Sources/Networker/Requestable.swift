//
//  File.swift
//  
//
//  Created by Scott Nicholes on 1/7/22.
//

import Foundation
import Combine

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol Requestable {
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var body: [String : Any]? { get }
    var headers: [String : String]? { get }
    associatedtype ResultType: Codable
}

extension Requestable {
    var method: HTTPMethod { return .get }
    var contentType: String { return "application/json" }
    var queryParams: [String : String]? { return nil }
    var body: [String : Any]? { return nil }
    var headers: [String : String]? { return nil }
}

extension Requestable {
    private func requestBodyFrom(params: [String : Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    func asURLRequest(baseURL: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        guard let fullUrl = urlComponents.url else { return nil }
        
        var request = URLRequest(url: fullUrl)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        request.allHTTPHeaderFields = headers
        return request
    }
}
