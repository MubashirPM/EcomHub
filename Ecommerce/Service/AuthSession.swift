//
//  AuthSession.swift
//  Ecommerce
//

import Foundation

/// Clears local session: Keychain tokens + `UserDefaults` used for signed-in state.
enum AuthSession {
    static func signOut() {
        AuthTokenStore.clear()
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userPhone")
        UserDefaults.standard.removeObject(forKey: "selectedAddressId")
        UserDefaults.standard.set("", forKey: UserDefaultsKeys.profileImageURL)
    }
}
