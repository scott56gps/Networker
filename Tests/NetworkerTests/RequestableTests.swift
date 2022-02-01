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
    
    func testEmptyBaseUrl_NilUrlRequest() {
        let urlRequest = testRequestable.asURLRequest(baseURL: "")
        XCTAssertNil(urlRequest)
    }
    
    func testRequestablePathIsFullUrl_NilUrlRequest() {
        let fullUrl = "https://www.google.com/hello"
        testRequestable = TestRequest(path: fullUrl)
        let urlRequest = testRequestable.asURLRequest(baseURL: testBaseUrl)
        XCTAssertNil(urlRequest)
    }
    
    func testPathEmpty_NonNilUrlRequest() {
        testRequestable = TestRequest(path: "")
        let urlRequest = testRequestable.asURLRequest(baseURL: testBaseUrl)
        XCTAssertNotNil(urlRequest)
    }
    
    func testPathNoPrefixSlash_NonNilUrlRequest() {
        let testPath = "hello"
        testRequestable = TestRequest(path: testPath)
        let urlRequest = testRequestable.asURLRequest(baseURL: testBaseUrl)
        XCTAssertNotNil(urlRequest)
    }
}

struct TestRequest: Requestable {
    typealias ResultType = String
    var path: String
}
