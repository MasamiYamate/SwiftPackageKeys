//
//  EnvironmentKey+Extension.swift
//  
//
//  Created by Masami on 2023/04/13.
//

import Foundation

extension EnvironmentKey {

    func translateLowerCamelCaseKey() -> EnvironmentKey {
        return EnvironmentKey(
            key: key.lowerCamelCase(),
            productionValue: fetchValue(stage: .production),
            stagingValue: fetchValue(stage: .staging),
            debugValue: fetchValue(stage: .debug)
        )
    }

}
