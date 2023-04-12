//
//  KeyValueGenerator.swift
//  
//
//  Created by Masami on 2023/04/06.
//

import Foundation

final class KeyValueGenerator {

    private let extensionCodeTemplate: String = """
%@

public final class SwiftPackageKeys {
%@
}
"""

    private let propertyCodeTemplate: String = """
    public static var %@: EnvironmentKey {
        EnvironmentKey(
            key: %@,
            productionValue: %@,
            stagingValue: %@,
            debugValue: %@
        )
    }

"""

    private let arguments: KeyGenerateArguments
    
    private let envValue: EnvironmentItem
    
    /// Initializes a new instance of the KeyGenerator class with the specified arguments and environment value.
    ///
    /// - Parameters:
    ///   - arguments: The arguments used to generate the key.
    ///   - envValue: The environment value used to generate the key.
    init(arguments: KeyGenerateArguments, envValue: EnvironmentItem) {
        self.arguments = arguments
        self.envValue = envValue
    }

    func writeCode() throws {
        let codeText = try loadExtensionCode()
        _ = FileManager.default.createFile(atPath: environmentExtensionCode.path, contents: codeText.data(using: .utf8))
    }

}

private extension KeyValueGenerator {

    var environmentExtensionCode: URL {
        arguments.workingDirectoryPath
            .appendingPathComponent("SwiftPackageKeys+Extension")
            .appendingPathExtension("swift")
    }

    var environmentKeyPath: URL {
        arguments.packageDirectoryPath
            .appendingPathComponent("KeyGenerator", isDirectory: true)
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("Models", isDirectory: true)
            .appendingPathComponent("EnvironmentKey")
            .appendingPathExtension("swift")
    }
    
    func loadExtensionCode() throws -> String {
        let environmentKeyTexts: [String] = envValue.keys.map { environmentKey -> String in
            loadKeysPropertyText(environmentKey: environmentKey)
        }
        let environmentKeyCodeText = environmentKeyTexts.joined(separator: "\n\n")
        let environmentKeyStructCodeText = try loadEnvironmentKeyText()
        return String(
            format: extensionCodeTemplate,
            arguments: [
                environmentKeyStructCodeText,
                environmentKeyCodeText
            ]
        )
    }

    func loadEnvironmentKeyText() throws -> String {
        return try String(contentsOf: environmentKeyPath)
    }

    func loadKeysPropertyText(environmentKey: EnvironmentKey) -> String {
        var productionValueText: String = "nil"
        if let productionValue = environmentKey.fetchValue(stage: .production) {
            productionValueText = "\"\(productionValue)\""
        }
        var stagingValueText: String = "nil"
        if let stagingValue = environmentKey.fetchValue(stage: .staging) {
            stagingValueText = "\"\(stagingValue)\""
        }
        var debugValueText: String = "nil"
        if let debugValue = environmentKey.fetchValue(stage: .debug) {
            debugValueText = "\"\(debugValue)\""
        }
        let key = environmentKey.key
        return String(
            format: propertyCodeTemplate,
            arguments: [
                key,
                "\"\(key)\"",
                "\(productionValueText)",
                "\(stagingValueText)",
                "\(debugValueText)"
            ]
        )
    }

}
