//
//  MockDataPublisher.swift
//  Networker
//
//  Created by Scott Nicholes on 12/31/25.
//
@testable import Networker
import Foundation
import Combine

struct MockDataPublisher: DataTaskPublisher {
    var result: Result<(Data, HTTPURLResponse), NetworkRequestError>
    
    func execute(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), NetworkRequestError> {
        result.publisher.eraseToAnyPublisher()
    }
}
