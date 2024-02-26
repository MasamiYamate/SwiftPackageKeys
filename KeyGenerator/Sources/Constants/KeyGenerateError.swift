//
//  KeyGenerateError.swift
//  
//
//  Created by Masami on 2023/04/04.
//

import Foundation

enum KeyGenerateError: Error, LocalizedError {
    case invalidFormatValueWasFound
    case failedToSetTheArguments
    case theEnvFileCouldNotBeFound
    case failedToReadTheFile

    var errorDescription: String? {
        switch self {
        case .invalidFormatValueWasFound:
            return "Invalid Format Value Was Found"
        case .failedToSetTheArguments:
            return "Failed To Set The Arguments"
        case .theEnvFileCouldNotBeFound:
            return "The Env File Could Not Be Found"
        case .failedToReadTheFile:
            return "Failed To Read The File"
        }
    }
}
