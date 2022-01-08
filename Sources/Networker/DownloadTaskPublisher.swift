//
//  DownloadTaskPublisher.swift
//  
//
//  Created by Scott Nicholes on 1/8/22.
//

import Foundation
import Combine

extension URLSession {
    public func downloadTaskPublisher(for url: URL) -> URLSession.DownloadTaskPublisher {
        self.downloadTaskPublisher(for: .init(url: url))
    }
    
    public func downloadTaskPublisher(for request: URLRequest) -> URLSession.DownloadTaskPublisher {
        .init(request: request, session: self)
    }
    
    public struct DownloadTaskPublisher: Publisher {
        public typealias Output = (url: URL, response: URLResponse)
        public typealias Failure = URLError
        
        public let request: URLRequest
        public let session: URLSession
        
        @available(macOS 10.15, *)
        @available(iOS 13.0, *)
        public func receive<S>(subscriber: S) where S : Subscriber, DownloadTaskPublisher.Failure == S.Failure, DownloadTaskPublisher.Output == S.Input {
            let subscription = DownloadTaskSubscription(subscriber: subscriber, session: self.session, request: self.request)
            subscriber.receive(subscription: subscription)
        }
    }
}
