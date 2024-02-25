//
//  Encryption.swift
//  
//
//  Created by Masami on 2023/09/07.
//

import CryptoKit
import Foundation

final class Encryption {

    static let shared: Encryption = Encryption()

    private(set) var encryptionKeyString: String = "%@"

    private var encryptionKey: SymmetricKey {
        SymmetricKey.make(base64EncodedString: encryptionKeyString)
    }

    private init() {}

    func makeSymmetricKey() {
        encryptionKeyString = SymmetricKey(size: .bits256).toString()
    }

    func encrypt(_ input: String) -> String {
        let data = input.data(using: .utf8)!
        let sealedBox = try! AES.GCM.seal(data, using: encryptionKey)
        let encryptedData = sealedBox.combined!
        return encryptedData.base64EncodedString()
    }

    func decrypt(_ input: String) -> String {
        let encryptedData = Data(base64Encoded: input)!
        let sealedBox = try! AES.GCM.SealedBox(combined: encryptedData)
        let data = try! AES.GCM.open(sealedBox, using: encryptionKey)
        return String(data: data, encoding: .utf8)!
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
