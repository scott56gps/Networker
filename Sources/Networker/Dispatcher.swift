//
//  Dispatcher.swift
//  Networker
//
//  Created by Scott Nicholes on 12/20/25.
//
import Foundation
import Combine

protocol Dispatcher {
    @available(iOS 13.0, *)
    func dispatch<T>(request: URLRequest, transform: @escaping (Data) throws -> T) -> AnyPublisher<T, NetworkRequestError>
}
