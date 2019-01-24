//
//  Extensions.swift
//  2bcc
//
//  Created by Apollo Zhu on 10/19/18.
//

extension Never: Error {
    public var localizedDescription: String { fatalError("Never") }
}

import Result

extension Result where Value == Void {
    static var success: Result {
        return .success(())
    }
}

import Commandant

extension InputFile.Encoding: ArgumentProtocol {
    static let name = "encoding"
}

extension InputFile.Format: ArgumentProtocol {
    static let name = "format"
}

public func curry<A, B, C, D, E, F>(_ function: @escaping ((A, B, C, D, E)) -> F)
    -> (A) -> (B) -> (C) -> (D) -> (E) -> F {
    return { a in { b in { c in { d in { e in function((a, b, c, d, e)) } } } } }
}
