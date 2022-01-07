import Combine

public struct Networker {
    var baseURL: String
    var networkDispatcher: NetworkDispatcher
    
    public init(baseURL: String, networkDispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.baseURL = baseURL
        self.networkDispatcher = networkDispatcher
    }
    
    @available(macOS 10.15, *)
    public func dispatch<R: Requestable>(_ request: R) -> AnyPublisher<R.ResultType, NetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            return Fail(outputType: R.ResultType.self, failure: NetworkRequestError.badRequest).eraseToAnyPublisher()
        }
        
        typealias RequestPublisher = AnyPublisher<R.ResultType, NetworkRequestError>
        let requestPublisher: RequestPublisher = networkDispatcher.dispatch(request: urlRequest)
        return requestPublisher.eraseToAnyPublisher()
    }
}
