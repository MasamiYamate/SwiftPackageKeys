//
//  KeyGenerateError.swift
//  
//
//  Created by Masami on 2023/04/04.
//

import Foundation

enum KeyGenerateError: Error {
    case invalidFormatValueWasFound
    case failedToSetTheArguments
    case theEnvFileCouldNotBeFound
    case failedToReadTheFile
}
