//
//  Encryption.swift
//  
//
//  Created by Masami on 2023/09/07.
//

import CryptoKit
import Foundation

final class Encryption {

    private enum EncryptionError: Error, LocalizedError {
        case encryptionFailed
        case decryptionFailed

        var errorDescription: String? {
            switch self {
            case .encryptionFailed:
                return "Encryption Failed"
            case .decryptionFailed:
                return "Decryption Failed"
            }
        }
    }

    static let shared: Encryption = Encryption()

    private var encryptionKey: SymmetricKey {
        let bytes = EncryptionKeyStore.shared.key.translateToString()
        return SymmetricKey.make(base64EncodedString: bytes)
    }

    private init() {}

    func makeSymmetricKey() {
        EncryptionKeyStore.shared.key = SymmetricKey(size: .bits256).toString().translateToUInt8Value()
    }

    func encrypt(_ input: String) throws -> String {
        let data = Data(input.utf8)
        let sealedBox = try AES.GCM.seal(data, using: encryptionKey)
        guard let encryptedData = sealedBox.combined else {
            throw EncryptionError.encryptionFailed
        }
        return encryptedData.base64EncodedString()
    }

    func decrypt(_ input: String) throws -> String {
        let encryptedData = Data(base64Encoded: input)!
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let data = try AES.GCM.open(sealedBox, using: encryptionKey)
        guard let decryptedValue = String(data: data, encoding: .utf8) else {
            throw EncryptionError.decryptionFailed
        }
        return decryptedValue
    }

}

fileprivate extension SymmetricKey {

    static func make(base64EncodedString: String) -> SymmetricKey {
        let data = Data(base64Encoded: base64EncodedString)!
        return SymmetricKey(data: data)
    }

    func toString() -> String {
        withUnsafeBytes { body in
            Data(body).base64EncodedString()
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
