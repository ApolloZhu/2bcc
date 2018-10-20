//
//  Definitions.swift
//  2bcc
//
//  Created by Apollo Zhu on 10/19/18.
//

let version = "1.0.0"

#if os(Linux)
let EX_OK: Int32 = 0
let EX_USAGE: Int32 = 64
#endif

enum InputFileFormat: String, CaseIterable {
    case srt
}

struct AnError: Error {
    let localizedDescription: String
    init(_ description: String) {
        localizedDescription = description
    }
}
