//
//  EncryptionKeyStore.swift
//
//
//  Created by Masami on 2024/07/19.
//

import Foundation

// Dummy Class
final class EncryptionKeyStore {

    var key: [UInt8] = []

    static let shared: EncryptionKeyStore = EncryptionKeyStore()
}
