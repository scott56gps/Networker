//
//  DataTaskPublisher.swift
//  Networker
//
//  Created by Scott Nicholes on 12/31/25.
//
import Foundation
import Combine

public protocol DataTaskPublisher {
    @available(iOS 13.0, *)
    func execute(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), NetworkRequestError>
}
