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
        var result: String?
        if stagingValue == nil,
           debugValue == nil {
            // If only the production environment key is set,
            // the production environment value will be returned for both Debug and Release schemes
            result = productionValue
        } else {
            #if DEBUG
            result = stagingValue
            #else
            result = productionValue
            #endif
        }
        guard let result else {
            return nil
        }
        return Encryption.shared.decrypt(result)
    }

    /// environment variable key
    public var key: String

    /// Retrieve the value associated with the key.
    /// - Parameter stage: Flags for each environment
    public func fetchValue(stage stageFlag: StageFlag) -> String? {
        var result: String?
        switch stageFlag {
        case .production:
            result = productionValue
        case .staging:
            result = stagingValue
        case .debug:
            result = debugValue
        }
        guard let result else {
            return nil
        }
        return Encryption.shared.decrypt(result)
    }

    // MARK: Value encrypted by a reversible cipher
    var productionValue: String?
    var stagingValue: String?
    var debugValue: String?

    enum CodingKeys: String, CodingKey {
        case key
        case productionValue
        case stagingValue
        case debugValue
    }

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
        debugValue: String? = nil
    ) {
        self.key = key
        self.productionValue = productionValue
        self.stagingValue = stagingValue
        self.debugValue = debugValue
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try values.decode(String.self, forKey: .key)
        if let productionRawValue: String = try? values.decode(String.self, forKey: .productionValue) {
            self.productionValue = Encryption.shared.encrypt(productionRawValue)
        }
        if let stagingRawValue: String = try? values.decode(String.self, forKey: .stagingValue) {
            self.stagingValue = Encryption.shared.encrypt(stagingRawValue)
        }
        if let debugRawValue: String = try? values.decode(String.self, forKey: .debugValue) {
            self.debugValue = Encryption.shared.encrypt(debugRawValue)
        }
    }

}
