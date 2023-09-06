//
//  Main.swift
//  
//
//  Created by Masami on 2023/04/03.
//

import Foundation

func main() throws {
    guard let arguments = KeyGenerateArguments(arguments: ProcessInfo.processInfo.arguments) else {
        throw KeyGenerateError.failedToSetTheArguments
    }
    Encryption.shared.encryptionKey = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    let loader = EnvLoader(arguments: arguments)
    let envValue = try loader.load()
    let generator = KeyValueGenerator(
        arguments: arguments,
        envValue: envValue
    )
    try generator.writeCode()
    let key = Encryption.shared.encryptionKey
    let encryptionCodeGenerator = EncryptionCodeGenerator(arguments: arguments, key: key)
    try encryptionCodeGenerator.writeCode()
}

do {
    try main()
} catch {
    fatalError(error.localizedDescription)
}
