//
//  NetworkDispatcher.swift
//  
//
//  Created by Scott Nicholes on 1/7/22.
//

import Foundation
import Combine

public struct APIClient {
    private let dataPublisher: DataTaskPublisher
    
    public init(dataPublisher: DataTaskPublisher) {
        self.dataPublisher = dataPublisher
    }
}

extension APIClient: Dispatcher {
    // Convenience initializer to provide default
    public init() {
        self.init(dataPublisher: URLSessionDataPublisher())
    }
    
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    func dispatch<T>(request: URLRequest, transform: @escaping (Data) throws -> T) -> AnyPublisher<T, NetworkRequestError> {
        return dataPublisher.execute(request)
            .tryMap { data, _ in
                try transform(data)
            }
            .mapError { error in
                error as? NetworkRequestError ?? .unknownError
            }
            .eraseToAnyPublisher()
    }
}
