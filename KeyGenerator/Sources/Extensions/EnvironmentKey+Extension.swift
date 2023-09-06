//
//  EnvironmentKey+Extension.swift
//  
//
//  Created by Masami on 2023/09/08.
//

import Foundation

extension EnvironmentKey {

    func translateLowerCamelCaseKey() -> EnvironmentKey {
        return EnvironmentKey(
            key: key.lowerCamelCase(),
            productionValue: fetchRawValue(stage: .production),
            stagingValue: fetchRawValue(stage: .staging),
            debugValue: fetchRawValue(stage: .debug)
        )
    }

    func fetchRawValue(stage stageFlag: StageFlag) -> String? {
        switch stageFlag {
        case .production:
            return productionValue
        case .staging:
            return stagingValue
        case .debug:
            return debugValue
        }
    }
    
}
