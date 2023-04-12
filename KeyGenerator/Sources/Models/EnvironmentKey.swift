//
//  EnvironmentKey.swift
//  
//
//  Created by Masami on 2023/04/06.
//

import Foundation

public struct EnvironmentKey: Decodable {

    /// flag for an environment variable
    public enum StageFlag {
        /// production environment
        case production
        /// staging environment
        case staging
        /// debug environment
        case debug
    }

    /// value of an environment variable
    public var value: String? {
        if stagingValue == nil,
           debugValue == nil {
            // If only the production environment key is set,
            // the production environment value will be returned for both Debug and Release schemes
            return productionValue
        } else {
            #if DEBUG
            return stagingValue
            #else
            return productionValue
            #endif
        }
    }

    /// environment variable key
    public var key: String

    private var productionValue: String?
    private var stagingValue: String?
    private var debugValue: String?

    /// Initializes a new instance of the EnvironmentVariable class.
    ///
    /// - Parameters:
    ///   - key: The name of the environment variable.
    ///   - productionValue: The value of the environment variable in the production environment.
    ///   - stagingValue: The value of the environment variable in the staging environment. Defaults to nil.
    ///   - debugValue: The value of the environment variable in the debug environment. Defaults to nil.
    init(
        key: String,
        productionValue: String?,
        stagingValue: String? = nil,
        debugValue: String? = nil) {
            self.key = key
            self.productionValue = productionValue
            self.stagingValue = stagingValue
            self.debugValue = debugValue
    }

    /// Retrieve the value associated with the key.
    /// - Parameter stage: Flags for each environment
    public func fetchValue(stage stageFlag: StageFlag) -> String? {
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
