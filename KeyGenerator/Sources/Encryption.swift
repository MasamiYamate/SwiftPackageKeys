//
//  Encryption.swift
//  
//
//  Created by Masami on 2023/09/07.
//

import CryptoKit
import Foundation

final class Encryption {

    private enum EncryptionError: Error {
        case encryptionFailed
        case decryptionFailed
    }

    static let shared: Encryption = Encryption()

    private(set) var encryptionKeyString: String = "%@"

    private var encryptionKey: SymmetricKey {
        SymmetricKey.make(base64EncodedString: encryptionKeyString)
    }

    private init() {}

    func makeSymmetricKey() {
        encryptionKeyString = SymmetricKey(size: .bits256).toString()
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
