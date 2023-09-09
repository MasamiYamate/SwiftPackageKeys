//
//  Encryption.swift
//  
//
//  Created by Masami on 2023/09/07.
//
//  Source
//  https://github.com/KyleBanks/XOREncryption/blob/master/Swift/XOREncryption.swift

import Foundation

final class Encryption {

    static let shared: Encryption = Encryption()

    var encryptionKey: String = "%@"

    private var encryptionKeyBytes: [UInt8] {
        return [UInt8](encryptionKey.utf8)
    }

    private init() {}

    func encrypt(_ input: String) -> String {
        let inputValueBytes = [UInt8](input.utf8)
        let encryptionKeyBytes = self.encryptionKeyBytes
        let encryptedBytes: [UInt8] = inputValueBytes.enumerated().map { byte in
            byte.element ^ encryptionKeyBytes[byte.offset]
        }
        guard let encryptedValue = String(bytes: encryptedBytes, encoding: .utf8),
              let percentEncodedValue = encryptedValue.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            fatalError("Encryption failed")
        }
        return percentEncodedValue.base64Encode()
    }

    func decrypt(_ input: String) -> String {
        let base64DecodedValue = input.base64Decode()
        guard let encryptedValue = base64DecodedValue.removingPercentEncoding else {
            fatalError("RemovingPercentEncoding failed")
        }
        let encryptedBytes = [UInt8](encryptedValue.utf8)
        let encryptionKeyBytes = self.encryptionKeyBytes
        let decrypted: [UInt8] = encryptedBytes.enumerated().map { byte in
            byte.element ^ encryptionKeyBytes[byte.offset]
        }
        guard let decryptedValue = String(bytes: decrypted, encoding: .utf8) else {
            fatalError("Decryption failed")
        }
        return decryptedValue
    }

}

private extension String {
    
    func base64Encode() -> String {
        guard let stringData = self.data(using: .utf8) else {
            fatalError("Base 64 encoding failed")
        }
        return stringData.base64EncodedString()
    }

    func base64Decode() -> String {
        guard let data = Data(base64Encoded: self),
              let decodedValue = String(data: data, encoding: .utf8) else {
            fatalError("Base 64 decoding failed")
        }
        return decodedValue
    }

}
