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

let version = "1.0.1"

func convert(options: ConvertCommand.Options) throws {
    let bcc: BCC
    
    print("Converting ".bold.blue + options.inputPath)
    
    switch options.inputFormat {
    case .srt:
        let srt = try SRT(
            path: options.inputPath,
            stringEncoding: String.Encoding(options.inputEncoding)
        )
        bcc = try BCC(srt: srt)
    }
    
    print("Saving to: ".bold.blue + options.outputPath)
    
    try bcc.write(to: URL(fileURLWithPath: options.outputPath))
    
    print("Done".bold.green)
}

CommandLine.main()
