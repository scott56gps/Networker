//
//  BodyProviding.swift
//  Networker
//
//  Created by Scott Nicholes on 1/6/26.
//
import Foundation

public protocol BodyProviding {
    func encodeBody() throws -> Data
    var contentType: String { get }
}
