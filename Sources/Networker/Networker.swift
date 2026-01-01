import Foundation
import Combine

public struct Networker {
    public var baseURL: URL
    var client: Dispatcher
    
    public init(baseURL: String, client: APIClient = APIClient()) {
        self.baseURL = URL(string: baseURL)!
        self.client = client
    }
    
    init(baseURL: String, client: Dispatcher) {
        self.baseURL = URL(string: baseURL)!
        self.client = client
    }
    
    @available(iOS 16.0, *)
    public func request<T: RequestConvertible>(_ request: T) -> AnyPublisher<T.Response, NetworkRequestError> {
        let urlRequest = toUrlRequest(request)
        return client.dispatch(request: urlRequest, transform: request.transform)
    }
    
    @available(iOS 13.0, *)
    public func request<T>(_ request: URLRequest, transform: @escaping (Data) throws -> T) -> AnyPublisher<T, NetworkRequestError> {
        return client.dispatch(request: request, transform: transform)
    }
    
    @available(iOS 13.0, *)
    public func request(_ request: URLRequest) -> AnyPublisher<Void, NetworkRequestError> {
        return client.dispatch(request: request) { _ in () }
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
