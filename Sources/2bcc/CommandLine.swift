//
//  CommandLine.swift
//  2bcc
//
//  Created by Apollo Zhu on 10/19/18.
//

import Foundation
import CommandLineKit
import Rainbow

let cli: CommandLineKit.CommandLine = {
    let cli = CommandLine()
    cli.formatOutput = { s, type in
        switch type {
        case .about:
            return s.bold + "\n"
        case .error:
            return s.red.bold + "\n\n"
        case .optionFlag:
            return "   \(s.green)\n"
        case .optionHelp:
            return s.split(separator: "\n").reduce("") { "\($0)      \($1)\n" }
        }
    }
    return cli
}()

func readParameters() -> Parameters {
    // MARK: Configure Parameters

    let source = StringOption(
        shortFlag: "i", longFlag: "in", required: true,
        helpMessage: "Path to the input caption file. Only supports srt."
    )
    cli.addOption(source)
    let inputFormat = EnumOption<InputFileFormat>(
        shortFlag: "f", longFlag: "format",
        helpMessage: "Input file format. Required if can't be inferred from file name."
    )
    cli.addOption(inputFormat)
    let inputEncoding = EnumOption<Encoding>(
        shortFlag: "e", longFlag: "encoding",
        helpMessage: "Input file encoding. Default to utf8."
    )
    cli.addOption(inputEncoding)
    let destination = StringOption(
        shortFlag: "o", longFlag: "out",
        helpMessage: """
    Path to the ouput bcc file. If not given, will be the same as input file.
    If not having suffix of ".bcc", that file extension will be added.
    """
    )
    cli.addOption(destination)
    let isVerbose = BoolOption(
        shortFlag: "v", longFlag: "verbose", helpMessage: "Print verbose messages."
    )
    cli.addOption(isVerbose)
    let printUsage = BoolOption(
        shortFlag: "h", longFlag: "help", helpMessage: "Print usage."
    )
    cli.addOption(printUsage)
    let printVersion = BoolOption(longFlag: "version", helpMessage: "Print version.")
    cli.addOption(printVersion)

    // MARK: - Handle Parameters

    func printInfoIfNeeded() {
        if printUsage.wasSet && printUsage.value {
            exitPrintingUsage()
        }
        if printVersion.wasSet && printVersion.value {
            print(version)
            exit(EX_OK)
        }
    }

    do {
        try cli.parse(strict: true)
    } catch {
        switch error {
        case CommandLineKit.CommandLine.ParseError.missingRequiredOptions:
            printInfoIfNeeded()
            fallthrough
        default:
            exitPrintingUsage(after: error)
        }
    }

    // MARK: - Infer Parameters

    let inputPath = source.value!
    let inferredInputFormat: InputFileFormat? = {
        let dot = inputPath.lastIndex(of: ".") ?? inputPath.startIndex
        return InputFileFormat(rawValue: "\(inputPath[inputPath.index(after: dot)...])")
    }()
    let format = inputFormat.value ?? inferredInputFormat ?? .srt

    let inferredOutputPath: String = {
        let suffix = ".\(format.rawValue)"
        if inputPath.hasSuffix(suffix) {
            let idx = inputPath.index(inputPath.endIndex, offsetBy: -suffix.count)
            return inputPath[..<idx] + ".bcc"
        } else {
            return inputPath + ".bcc"
        }
    }()
    let outputPath = destination.value ?? inferredOutputPath

    return Parameters(
        inputPath: inputPath,
        inputFormat: format,
        inputEncoding: String.Encoding(inputEncoding.value ?? .utf8),
        outputPath: outputPath,
        isVerbose: isVerbose.value
    )
}

func exitPrintingUsage(after error: Error? = nil) -> Never {
    if let error = error {
        cli.printUsage(error)
    } else {
        cli.printUsage()
    }
    exit(EX_USAGE)
}
