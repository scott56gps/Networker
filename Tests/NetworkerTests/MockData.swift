//
//  MockData.swift
//  Networker
//
//  Created by Scott Nicholes on 12/31/25.
//
import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
}

enum MockData {
    static func json<T: Encodable>(from value: T, encoder: JSONEncoder = JSONEncoder()) -> Data {
        try! encoder.encode(value)
    }
}

extension MockData {
    static func jsonString(_ string: String) -> Data {
        Data(string.utf8)
    }
}
