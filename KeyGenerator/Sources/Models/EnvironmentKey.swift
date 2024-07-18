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
        guard let result,
              let decryptedValue = try? Encryption.shared.decrypt(result) else {
            return nil
        }
        return decryptedValue
    }

    /// environment variable key
    public var key: String {
        set {
            keyRawValue = newValue.translateToUInt8Value()
        }
        get {
            keyRawValue.translateToString()
        }
    }

    // MARK: Value encrypted by a reversible cipher
    var productionValue: String? {
        set {
            productionRawValue = newValue?.translateToUInt8Value()
        }
        get {
            productionRawValue?.translateToString()
        }
    }
    var stagingValue: String? {
        set {
            stagingRawValue = newValue?.translateToUInt8Value()
        }
        get {
            stagingRawValue?.translateToString()
        }
    }
    var debugValue: String? {
        set {
            debugRawValue = newValue?.translateToUInt8Value()
        }
        get {
            debugRawValue?.translateToString()
        }
    }

    var keyRawValue: [UInt8]
    var productionRawValue: [UInt8]?
    var stagingRawValue: [UInt8]?
    var debugRawValue: [UInt8]?

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
        keyRawValue: [UInt8],
        productionRawValue: [UInt8]?,
        stagingRawValue: [UInt8]? = nil,
        debugRawValue: [UInt8]? = nil
    ) {
        self.keyRawValue = keyRawValue
        self.productionRawValue = productionRawValue
        self.stagingRawValue = stagingRawValue
        self.debugRawValue = debugRawValue
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
        self.keyRawValue = key.translateToUInt8Value()
        self.productionRawValue = productionValue?.translateToUInt8Value()
        self.stagingRawValue = stagingValue?.translateToUInt8Value()
        self.debugRawValue = debugValue?.translateToUInt8Value()
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.keyRawValue = try values.decode(String.self, forKey: .key).translateToUInt8Value()
        if let productionRawValue = try? values.decode(String.self, forKey: .productionValue),
           let decryptedProductionValue = try? Encryption.shared.encrypt(productionRawValue) {
            self.productionRawValue = decryptedProductionValue.translateToUInt8Value()
        }
        if let stagingRawValue = try? values.decode(String.self, forKey: .stagingValue),
           let decryptedStagingValue = try? Encryption.shared.encrypt(stagingRawValue) {
            self.stagingRawValue = decryptedStagingValue.translateToUInt8Value()
        }
        if let debugRawValue = try? values.decode(String.self, forKey: .debugValue),
           let decryptedDebugValue = try? Encryption.shared.encrypt(debugRawValue) {
            self.debugRawValue = decryptedDebugValue.translateToUInt8Value()
        }
    }

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
        guard let result,
              let decryptedValue = try? Encryption.shared.decrypt(result) else {
            return nil
        }
        return decryptedValue
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

fileprivate extension Array where Element == UInt8 {
    func translateToString() -> String {
        guard let value = String(bytes: self, encoding: .utf8) else {
            fatalError()
        }
        return value
    }
}

fileprivate extension String {
    func translateToUInt8Value() -> [UInt8] {
        return [UInt8](self.utf8)
    }
}
