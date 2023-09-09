//
//  EncryptionCodeGenerator.swift
//  
//
//  Created by Masami on 2023/09/08.
//

import Foundation

final class EncryptionCodeGenerator {
    
    private let arguments: KeyGenerateArguments
    
    private let key: String
    
    init(arguments: KeyGenerateArguments, key: String) {
        self.arguments = arguments
        self.key = key
    }

    func writeCode() throws {
        let codeText = try loadEncryptionCodeText()
        _ = FileManager.default.createFile(atPath: encryptionCode.path, contents: codeText.data(using: .utf8))
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
    
    func loadEncryptionCodeTemplateText() throws -> String {
        return try String(contentsOf: encryptionCodeTemplatePath)
    }

    func loadEncryptionCodeText() throws -> String {
        let template = try loadEncryptionCodeTemplateText()
        return String(
            format: template,
            arguments: [
                key
            ]
        )
    }

}
