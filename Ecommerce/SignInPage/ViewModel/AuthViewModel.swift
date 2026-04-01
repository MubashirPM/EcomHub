//
//  AuthViewModel.swift
//  Ecommerce
//

import Combine
import Foundation
import SwiftUI

/// `ObservableObject` is not MainActor-isolated; keep the class nonisolated and mark entry points `@MainActor` so `@Published` updates stay on the main thread (Swift 6).
final class AuthViewModel: ObservableObject {

    @Published private(set) var isLoggedIn = false
    @Published private(set) var isLoading = false
    /// True until the first `validateUser()` run finishes (app cold start).
    @Published private(set) var isBootstrapping = true

    /// Validates stored JWT via `GET /home`. Call on app launch.
    @MainActor
    func validateUser() async {
        isLoading = true
        defer {
            isLoading = false
            isBootstrapping = false
        }

        guard let token = AuthTokenStore.getAccessToken(), !token.isEmpty else {
            isLoggedIn = false
            return
        }

        do {
            let ok = try await AuthService.fetchHome()
            if ok {
                isLoggedIn = true
            } else {
                AuthSession.signOut()
                isLoggedIn = false
            }
        } catch {
            isLoggedIn = false
        }
    }

    /// Clears Keychain token and app session flags (`AuthSession` uses `AuthTokenStore.clear()`).
    @MainActor
    func logout() {
        AuthSession.signOut()
        isLoggedIn = false
    }

    /// Call after email/Google login succeeds and token is saved.
    @MainActor
    func markLoggedInAfterLogin() {
        isLoggedIn = true
    }
}
