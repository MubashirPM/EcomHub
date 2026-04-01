//
//  KeychainTokenStorage.swift
//  Ecommerce
//
//  Stores access and refresh tokens in the Keychain (not in UserDefaults).
//

import Foundation
import Security

enum KeychainTokenStorage {

    private enum Key: String {
        case accessToken = "com.ecommerce.auth.accessToken"
        case refreshToken = "com.ecommerce.auth.refreshToken"
    }

    static func save(accessToken: String, refreshToken: String?) {
        save(accessToken, for: Key.accessToken.rawValue)
        if let refreshToken, !refreshToken.isEmpty {
            save(refreshToken, for: Key.refreshToken.rawValue)
        } else {
            delete(Key.refreshToken.rawValue)
        }
    }

    static func accessToken() -> String? {
        read(Key.accessToken.rawValue)
    }

    static func refreshToken() -> String? {
        read(Key.refreshToken.rawValue)
    }

    static func clear() {
        delete(Key.accessToken.rawValue)
        delete(Key.refreshToken.rawValue)
    }

    private static func save(_ value: String, for account: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private static func read(_ account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private static func delete(_ account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
