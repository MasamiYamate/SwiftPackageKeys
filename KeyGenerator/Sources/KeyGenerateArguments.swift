//
//  KeyGenerateArguments.swift
//  
//
//  Created by Masami on 2023/04/03.
//

import Foundation

struct KeyGenerateArguments {

    private enum Argument: Int, CaseIterable {
        case executableFilePath
        case packageDirectoryPath
        case workingDirectoryPath
    }

    private var arguments: [String]

    var executableFilePath: URL {
        URL(fileURLWithPath: fetchArgument(.executableFilePath))
    }

    var packageDirectoryPath: URL {
        URL(fileURLWithPath: fetchArgument(.packageDirectoryPath))
    }

    var workingDirectoryPath: URL {
        URL(fileURLWithPath: fetchArgument(.workingDirectoryPath))
    }

    init?(arguments: [String]) {
        guard arguments.count == Argument.allCases.count else {
            return nil
        }
        self.arguments = arguments
    }

    private func fetchArgument(_ argument: Argument) -> String {
        arguments[argument.rawValue]
    }
}
