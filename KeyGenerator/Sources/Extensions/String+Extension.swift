//
//  String+Extension.swift
//
//
//  Created by Masami on 2023/04/06.
//

import Foundation

extension String {
    /// Convert the input string to lower camel case.
    /// - Returns: The lower camel case version of the input string.
    func lowerCamelCase() -> String {
        guard !isLowerCamelCase() else {
            return self
        }
        let words = self.split(separator: "_").enumerated()
        var lowerCamelCase = ""
        for (index, word) in words {
            if index == 0 {
                lowerCamelCase += word.lowercased()
            } else {
                lowerCamelCase += word.prefix(1).uppercased() + word.dropFirst().lowercased()
            }
        }
        return lowerCamelCase
    }

    private func isLowerCamelCase() -> Bool {
        let pattern = "^[a-z]+(?:[A-Z][a-z0-9]+)*$"
        return self.range(of: pattern, options: .regularExpression) != nil
    }

}
