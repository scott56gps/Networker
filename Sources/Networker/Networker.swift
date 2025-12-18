import Foundation
import Combine

public struct Networker {
    public var baseURL: URL
    var networkDispatcher: NetworkDispatcher
    
    public init(baseURL: String, networkDispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.baseURL = URL(string: baseURL)!
        self.networkDispatcher = networkDispatcher
    }
    
    @available(iOS 16.0, *)
    func request<T: RequestConvertible>(_ request: T) -> AnyPublisher<T.Response, NetworkRequestError> {
        let urlRequest = toUrlRequest(request)
        return networkDispatcher.dispatch(request: urlRequest, transform: request.transform)
    }
    
    @available(iOS 13.0, *)
    public func request<T>(_ request: URLRequest, transform: @escaping (Data) throws -> T) -> AnyPublisher<T, NetworkRequestError> {
        return networkDispatcher.dispatch(request: request, transform: transform)
    }
    
    @available(iOS 13.0, *)
    public func request(_ request: URLRequest) -> AnyPublisher<Void, NetworkRequestError> {
        return networkDispatcher.dispatch(request: request) { _ in () }
    }
    
    @available(iOS 16.0, *)
    private func toUrlRequest<T: RequestConvertible>(_ request: T) -> URLRequest {
        let url = request.queryParameters.map { queryParams in
            baseURL.appending(path: request.path).appending(queryItems: queryParams)
        } ?? baseURL.appending(path: request.path)
        
        var urlRequest = URLRequest(url: url, cachePolicy: request.cachePolicy)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers
        
        return urlRequest
    }
}
