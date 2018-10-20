//
//  BCC.swift
//  2bcc
//
//  Created by Apollo Zhu on 10/19/18.
//

import Foundation

public struct BCC: Codable {
    public let font_size = 0.4
    public let font_color = "#FFFFFF"
    public let background_alpha = 0.5
    public let background_color = "#9C27B0"
    public let Stroke = "none"
    public var body: [Subtitle]
    public struct Subtitle: Codable {
        public let from: Double
        public let to: Double
        public let location = 2
        public let content: String

        public init(from: Double, to: Double, content: String) {
            self.from = from
            self.to = to
            self.content = content
        }
    }
}

extension BCC {
    /// Write the contents of self to a location in bcc format.
    ///
    /// - parameter url: The location to write the data into.
    /// - parameter options: Options for writing the data. Default value is `[]`.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    /// - throws: An error in the Cocoa domain, if there is an error writing to the `URL`.
    public func write(to url: URL, options: Data.WritingOptions = []) throws {
        let data = try JSONEncoder().encode(self)
        try data.write(to: url, options: options)
    }
}
