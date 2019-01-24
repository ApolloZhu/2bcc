//
//  CommandLine.swift
//  2bcc
//
//  Created by Apollo Zhu on 10/19/18.
//

import Foundation
import Commandant
import Result

typealias CLIError = CommandantError<Never>

struct VersionCommand: CommandProtocol {
    let verb = "version"
    let function = "Print version"
    
    func run(_ options: NoOptions<Never>) -> Result<(), Never> {
        print(version)
        return .success
    }
}

struct ConvertCommand: CommandProtocol {
    let verb = "convert"
    let function = "Convert srt to bcc format"
    func run(_ options: Options) -> Result<(), Never> {
        return Result(catching: { try convert(options: options) })
    }
    struct Options: OptionsProtocol {
        let inputPath: String
        let inputFormat: InputFile.Format
        let inputEncoding: InputFile.Encoding
        let outputPath: String
        let isVerbose: Bool
        
        static func evaluate(_ m: CommandMode) -> Result<Options, CLIError> {
            let input: Result<String, CLIError> =
                m <| Argument(usage: "Path to the input caption file. Only supports srt.")
            let format: Result<InputFile.Format, CLIError> = (m <| Option<InputFile.Format?>(
                key: "format", defaultValue: nil,
                usage: "Input file format. Required if can't be inferred from file name."))
                .flatMap { format in
                    input.flatMap { inputPath in
                        var inferredInputFormat: InputFile.Format? {
                            let dot = inputPath.lastIndex(of: ".") ?? inputPath.startIndex
                            let ext = "\(inputPath[inputPath.index(after: dot)...])"
                            return InputFile.Format(rawValue: ext)
                        }
                        return Result(
                            format ?? inferredInputFormat,
                            failWith: CLIError.usageError(description: "Can't infer input file format.")
                        )
                    }
            }
            let encoding: Result<InputFile.Encoding, CLIError> =
                m <| Option(key: "encoding", defaultValue: .utf8, usage: "Input file encoding. Default to utf8.")
            let output: Result<String, CLIError> = (m <| Option<String?>(
                key: "out", defaultValue: nil, usage: """
                Path to the ouput bcc file. If not given, will be the same as input file.
                If not having suffix of ".bcc", that file extension will be added.
                """)).flatMap { outputPath in
                    input.flatMap { inputPath in
                        format.map { format in
                            var inferredOutputPath: String {
                                let suffix = ".\(format.rawValue)"
                                if inputPath.hasSuffix(suffix) {
                                    let idx = inputPath.index(inputPath.endIndex, offsetBy: -suffix.count)
                                    return inputPath[..<idx] + ".bcc"
                                } else {
                                    return inputPath + ".bcc"
                                }
                            }
                            return outputPath ?? inferredOutputPath
                        }
                    }
            }
            return curry(self.init) <*> input <*> format <*> encoding <*> output
                <*> m <| Switch(flag: "v", key: "verbose", usage: "Show verbose output")
        }
    }
}

extension CommandLine {
    static func main() {
        let commands = CommandRegistry<Never>()
        commands.register(HelpCommand(registry: commands))
        commands.register(VersionCommand())
        commands.register(ConvertCommand())
        let args = CommandLine.arguments
        if args.count == 2,
            case .success? = commands.run(command: "convert", arguments: [args[1]]) {
            exit(EXIT_SUCCESS)
        }
        commands.main(arguments: args, defaultVerb: "help") { error in
            fputs(error.localizedDescription + "\n", stderr)
        }
    }
}
