//
//  EnvironmentItem.swift
//  
//
//  Created by Masami on 2023/04/06.
//

import Foundation

struct EnvironmentItem: Decodable {
    var keys: [EnvironmentKey]

    /// Load EnvironmentJson from .env file
    /// - Parameter contents: string of env file
    /// - Returns: EnvironmentKeys
    static func load(_ contents: String) throws -> EnvironmentItem {
        let separator: String = "="
        let lines = contents.components(separatedBy: .newlines)
        let keys: [EnvironmentKey] = lines.compactMap { line -> EnvironmentKey? in
            let parts: [String] = line.components(separatedBy: separator)
            guard parts.count == 2,
                  let key = parts.first?.trimmingCharacters(in: .whitespacesAndNewlines).lowerCamelCase(),
                  let productionValue = parts.last?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return nil
            }
            return EnvironmentKey(key: key, productionValue: productionValue)
        }
        return EnvironmentItem(keys: keys)
    }
}
