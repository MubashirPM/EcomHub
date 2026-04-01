//
//  AuthTokenStore.swift
//  Ecommerce
//
//  Single place to read/write tokens. Only the access token is used on API requests.
//  Refresh token is stored for a future refresh flow (not sent on normal calls).
//

import Foundation

enum AuthTokenStore {

    /// Saves only the access token (no refresh token).
    static func saveAccessToken(_ token: String) {
        KeychainTokenStorage.save(accessToken: token, refreshToken: nil)
    }

    static func getAccessToken() -> String? {
        KeychainTokenStorage.accessToken()
    }

    static func clearToken() {
        KeychainTokenStorage.clear()
    }

    static func save(accessToken: String, refreshToken: String?) {
        KeychainTokenStorage.save(accessToken: accessToken, refreshToken: refreshToken)
    }

    static var accessToken: String? {
        KeychainTokenStorage.accessToken()
    }

    static var refreshToken: String? {
        KeychainTokenStorage.refreshToken()
    }

    static func clear() {
        KeychainTokenStorage.clear()
    }
}
