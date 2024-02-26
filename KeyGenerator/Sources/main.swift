//
//  Main.swift
//  
//
//  Created by Masami on 2023/04/03.
//

import CryptoKit
import Foundation

func main() throws {
    guard let arguments = KeyGenerateArguments(arguments: ProcessInfo.processInfo.arguments) else {
        throw KeyGenerateError.failedToSetTheArguments
    }
    Encryption.shared.makeSymmetricKey()
    let loader = EnvLoader(arguments: arguments)
    let envValue = try loader.load()
    let generator = KeyValueGenerator(
        arguments: arguments,
        envValue: envValue
    )
    try generator.writeCode()
    let key = Encryption.shared.encryptionKeyString
    let encryptionCodeGenerator = EncryptionCodeGenerator(arguments: arguments, key: key)
    try encryptionCodeGenerator.writeCode()
}

do {
    try main()
} catch {
    print("SwiftPackageKeys Error: \(error.localizedDescription)")
    fatalError(error.localizedDescription)
}
