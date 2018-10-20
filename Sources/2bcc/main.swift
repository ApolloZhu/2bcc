//
//  main.swift
//  2bcc
//
//  Created by Apollo Zhu on 10/19/18.
//

import Foundation
import Rainbow
import bcc
import srt

struct Parameters {
    let inputPath: String
    let inputFormat: InputFileFormat
    let inputEncoding: String.Encoding
    let outputPath: String
    let isVerbose: Bool
}

func convert() throws {
    let args = readParameters()

    let bcc: BCC

    print("Converting \(args.inputPath)")

    switch args.inputFormat {
    case .srt:
        let srt = try SRT(path: args.inputPath, stringEncoding: args.inputEncoding)
        bcc = try BCC(srt: srt, verbose: args.isVerbose)
    }

    print("Saving to: \(args.outputPath)")

    try bcc.write(to: URL(fileURLWithPath: args.outputPath))

    print("Done".green)
}

do {
    try convert()
} catch {
    print(error.localizedDescription.red.bold)
    exit(Int32((error as NSError).code))
}
