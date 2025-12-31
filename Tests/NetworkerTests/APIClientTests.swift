//
//  APIClientTests.swift
//  Networker
//
//  Created by Scott Nicholes on 12/31/25.
//

import XCTest
import Combine

@testable import Networker

final class APIClientTests: XCTestCase {
    var successfulResponse: HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    var request = URLRequest(url: URL(string: "https://example.com")!)
    private var cancellables: Set<AnyCancellable> = []

    
    func testDispatch_SingleTransformedValue() {
        let movie = Movie(id: 1, title: "Tommy Boy")
        
        let mockPublisher = MockDataPublisher(
            result: .success((MockData.json(from: movie), successfulResponse))
        )
        let apiClient = APIClient(dataPublisher: mockPublisher)
        
        let allPropertiesMatchExpectation = expectation(description: "Returned value has properties matching the original")
        
        apiClient.dispatch(request: request, transform: { data in
            return try JSONDecoder().decode(Movie.self, from: data)
        })
        .sink(receiveCompletion: { _ in }, receiveValue: { value in
            XCTAssert(value.title == movie.title)
            XCTAssert(value.id == movie.id)
            allPropertiesMatchExpectation.fulfill()
        })
        .store(in: &cancellables)
        
        wait(for: [allPropertiesMatchExpectation], timeout: 1)
    }
    
    func testDispatch_MultipleTransformedValues() {
        let movies: [Movie] = [
            Movie(id: 1, title: "The Shawshank Redemption"),
            Movie(id: 2, title: "The Godfather"),
            Movie(id: 3, title: "The Dark Knight"),
            Movie(id: 4, title: "12 Angry Men"),
        ]
        
        let mockPublisher = MockDataPublisher(
            result: .success((MockData.json(from: movies), successfulResponse))
        )
        let apiClient = APIClient(dataPublisher: mockPublisher)
        
        let returnedValueHasCountMatchingExpectation = expectation(description: "The returned value is an array matching the length of the original")
        let allPropertiesForEachMatchExpectation = expectation(description: "All models have properties matching the originals")
        
        apiClient.dispatch(request: request, transform: { data in
            return try JSONDecoder().decode([Movie].self, from: data)
        })
        .sink(receiveCompletion: { _ in }, receiveValue: { value in
            XCTAssertTrue(value.count == 4)
            returnedValueHasCountMatchingExpectation.fulfill()
            for returnedMovie in value {
                XCTAssertTrue(movies.contains { movie in movie.id == returnedMovie.id && movie.title == returnedMovie.title })
            }
            allPropertiesForEachMatchExpectation.fulfill()
        })
        .store(in: &cancellables)
        
        wait(for: [returnedValueHasCountMatchingExpectation, allPropertiesForEachMatchExpectation], timeout: 1)
    }
    
    func testDispatch_VoidTransformValue() {
        let mockPublisher = MockDataPublisher(result: .success((Data(), successfulResponse)))
        let apiClient = APIClient(dataPublisher: mockPublisher)
        
        let networkOperationFinished = expectation(description: "The requested operation finished with no errors")
        
        apiClient.dispatch(request: request, transform: { _ in
            return ()
        })
        // We are testing for side-effects here.  The best we can do is verify that the completion "finished"
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                networkOperationFinished.fulfill()
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
        
        wait(for: [networkOperationFinished], timeout: 1)
    }
}
