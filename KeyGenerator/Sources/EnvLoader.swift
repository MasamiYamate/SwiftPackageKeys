//
//  EnvLoader.swift
//  
//
//  Created by Masami on 2023/04/04.
//

import Foundation

final class EnvLoader: NSObject {
    
    private let arguments: KeyGenerateArguments

    private let semaphore = DispatchSemaphore(value: 0)

    private var workspacePath: URL?
    
    init(arguments: KeyGenerateArguments) {
        self.arguments = arguments
    }

    func load() throws -> EnvironmentItem {
        loadWorkspacePath()
        semaphore.wait()
        if let envValue = try? fetchEnv() {
            return envValue
        } else if let envJsonValue = try? fetchEnvJson() {
            return envJsonValue
        } else {
            throw KeyGenerateError.invalidFormatValueWasFound
        }
    }

}

extension EnvLoader: XMLParserDelegate {

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let value = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let filePath = URL(fileURLWithPath: value)
        guard filePath.pathExtension == "xcodeproj" else {
            return
        }
        workspacePath = filePath.deletingLastPathComponent()
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        semaphore.signal()
    }

}

private extension EnvLoader {

    var derivedDataPath: URL {
        return arguments.packageDirectoryPath
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    var infoPlistPath: URL {
        derivedDataPath
            .appendingPathComponent("info")
            .appendingPathExtension("plist")
    }

    var envFilePath: URL? {
        workspacePath?.appendingPathComponent(".env")
    }

    var envJsonFilePath: URL? {
        workspacePath?.appendingPathComponent(".env.json")
    }

    func loadWorkspacePath() {
        let parser = XMLParser(contentsOf: infoPlistPath)
        parser?.delegate = self
        parser?.parse()
    }
    
    func fetchEnv() throws -> EnvironmentItem? {
        guard let envFilePath = envFilePath else {
            throw KeyGenerateError.theEnvFileCouldNotBeFound
        }
        let contents = try String(contentsOf: envFilePath)
        return try EnvironmentItem.load(contents)
    }

    func fetchEnvJson() throws -> EnvironmentItem {
        guard let envJsonFilePath = envJsonFilePath else {
            throw KeyGenerateError.theEnvFileCouldNotBeFound
        }
        let contents = try String(contentsOf: envJsonFilePath)
        guard let data = contents.data(using: .utf8) else {
            throw KeyGenerateError.failedToReadTheFile
        }
        let item = try JSONDecoder().decode(EnvironmentItem.self, from: data)
        let keys = item.keys.map { $0.translateLowerCamelCaseKey() }
        return EnvironmentItem(keys: keys)
    }

}
