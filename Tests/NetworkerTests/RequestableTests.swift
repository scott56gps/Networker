//
//  File.swift
//  
//
//  Created by Scott Nicholes on 1/31/22.
//

import XCTest
@testable import Networker

final class RequestableTests: XCTestCase {
    var testRequestable = TestRequest(path: "/example")
    let testBaseUrl = "www.google.com"
    
    func testNoQueryParams_NonNilUrlRequest() {
        let urlRequest = testRequestable.asURLRequest(baseURL: testBaseUrl)
        XCTAssertNotNil(urlRequest)
    }
    
    func testWithQueryParams_NonNilUrlRequest() {
        let queryParams = ["my_key" : "is cool"]
        testRequestable.queryParams = queryParams
        let urlRequest = testRequestable.asURLRequest(baseURL: testBaseUrl)
        XCTAssertNotNil(urlRequest)

    }
    
    func testEmptyBaseUrl_NilUrlRequest() {
        let urlRequest = testRequestable.asURLRequest(baseURL: "")
        XCTAssertNil(urlRequest)
    }
    
    func testRequestablePathIsFullUrl_NilUrlRequest() {
        let fullUrl = "https://www.google.com/hello"
        testRequestable.path = fullUrl
        let urlRequest = testRequestable.asURLRequest(baseURL: testBaseUrl)
        XCTAssertNil(urlRequest)
    }
    
    func testPathEmpty_NonNilUrlRequest() {
        let emptyPath = ""
        testRequestable.path = emptyPath
        let urlRequest = testRequestable.asURLRequest(baseURL: testBaseUrl)
        XCTAssertNotNil(urlRequest)
    }
    
    func testPathNoPrefixSlash_NonNilUrlRequest() {
        let pathWithNoPrefixSlash = "hello"
        testRequestable.path = pathWithNoPrefixSlash
        let urlRequest = testRequestable.asURLRequest(baseURL: testBaseUrl)
        XCTAssertNotNil(urlRequest)
    }
}

struct TestRequest: Requestable {
    typealias ResultType = String
    var path: String
    var queryParams: [String : String]?
    
    init(path: String, queryParams: [String : String]? = nil) {
        self.path = path
        self.queryParams = queryParams
    }
}
