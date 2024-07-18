//
//  EnvironmentKey+Extension.swift
//
//
//  Created by Masami on 2024/07/25.
//

import Foundation

extension EnvironmentKey {

    func translateLowerCamelCaseKey() -> EnvironmentKey {
        return EnvironmentKey(
            keyRawValue: key.lowerCamelCase().translateToUInt8Value(),
            productionRawValue: fetchRawValue(stage: .production)?.translateToUInt8Value(),
            stagingRawValue: fetchRawValue(stage: .staging)?.translateToUInt8Value(),
            debugRawValue: fetchRawValue(stage: .debug)?.translateToUInt8Value()
        )
    }

}

fileprivate extension String {
    func translateToUInt8Value() -> [UInt8] {
        return [UInt8](self.utf8)
    }
}
