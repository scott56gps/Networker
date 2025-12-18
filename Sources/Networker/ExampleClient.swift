//
//  ExampleClient.swift
//  Networker
//
//  Created by Scott Nicholes on 12/16/25.
//

import Foundation
import Combine

struct Movie: Decodable {
    let id: String
    let name: String
    let overview: String
}

struct GetMovieRequest: RequestConvertible {
    typealias Response = Movie
    let movieId: String
    var path: String { "movie/\(movieId)" }
}

@available(iOS 16.0, *)
struct ExampleClient {
    let networker: Networker
    
    init(networker: Networker) {
        self.networker = networker
    }
    
    func makeRequest() {
        networker.request(GetMovieRequest(movieId: "1"))
            .sink(receiveCompletion: { _ in }, receiveValue: { movie in
                print(movie.name)
            })
    }
}
