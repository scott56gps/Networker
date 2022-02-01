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
    var queryParams: [String : String]? { get }
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
    func asURLRequest(baseURL: String) -> URLRequest? {
        if baseURL.isEmpty { return nil }
        
        guard let url = constructUrl(baseURL: baseURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private func requestBodyFrom(params: [String : Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    private func constructUrl(baseURL: String) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        guard let pathComponent = URLComponents(string: path) else { return nil }
        urlComponents.path.append(pathComponent.path)
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return urlComponents.url
    }
}
