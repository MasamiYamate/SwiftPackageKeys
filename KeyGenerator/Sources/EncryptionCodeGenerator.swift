//
//  EncryptionCodeGenerator.swift
//  
//
//  Created by Masami on 2023/09/08.
//

import Foundation

final class EncryptionCodeGenerator {
    
    private let arguments: KeyGenerateArguments
    
    private let keyBytesString: String

    init(arguments: KeyGenerateArguments, keyBytes: [UInt8]) {
        self.arguments = arguments
        self.keyBytesString = keyBytes.map { String($0) }.joined(separator: ",")
        print(keyBytesString)
    }

    func writeCode() throws {
        let codeText = try loadEncryptionCodeTemplateText()
        _ = FileManager.default.createFile(atPath: encryptionCode.path, contents: codeText.data(using: .utf8))
        let encryptionKeyStoreText = try loadEncryptionKeyStoreCodeText()
        _ = FileManager.default.createFile(atPath: encryptionKeyStoreCode.path, contents: encryptionKeyStoreText.data(using: .utf8))
    }

}

private extension EncryptionCodeGenerator {

    var encryptionCode: URL {
        arguments.workingDirectoryPath
            .appendingPathComponent("Encryption")
            .appendingPathExtension("swift")
    }

    var encryptionCodeTemplatePath: URL {
        arguments.packageDirectoryPath
            .appendingPathComponent("KeyGenerator", isDirectory: true)
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("Encryption")
            .appendingPathExtension("swift")
    }

    var encryptionKeyStoreCode: URL {
        arguments.workingDirectoryPath
            .appendingPathComponent("EncryptionKeyStoreCode")
            .appendingPathExtension("swift")
    }

    var encryptionKeyStoreTemplatePath: URL {
        arguments.packageDirectoryPath
            .appendingPathComponent("KeyGenerator", isDirectory: true)
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("Constants", isDirectory: true)
            .appendingPathComponent("Template")
            .appendingPathComponent("EncryptionKeyStoreCode")
            .appendingPathExtension("txt")
    }

    func loadEncryptionCodeTemplateText() throws -> String {
        return try String(contentsOf: encryptionCodeTemplatePath)
    }

    func loadEncryptionKeyStoreTemplateText() throws -> String {
        return try String(contentsOf: encryptionKeyStoreTemplatePath)
    }

    func loadEncryptionKeyStoreCodeText() throws -> String {
        let template = try loadEncryptionKeyStoreTemplateText()
        return String(
            format: template,
            arguments: [
                "[\(keyBytesString)]"
            ]
        )
    }

}
