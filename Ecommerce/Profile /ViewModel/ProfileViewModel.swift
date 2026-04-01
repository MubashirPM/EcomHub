//
//  ProfileViewModel.swift
//  Ecommerce
//

import Foundation
import Combine
import SwiftUI

enum UserDefaultsKeys {
    static let profileImageURL = "profileImageURL"
}

@MainActor
class ProfileViewModel: ObservableObject {

    @Published var user: ProfileUser?
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?

    func clearUserOnLogout() {
        user = nil
        errorMessage = nil
    }

    func fetchProfile(userId: String) async {
        guard !userId.isEmpty else {
            user = nil
            UserDefaults.standard.set("", forKey: UserDefaultsKeys.profileImageURL)
            return
        }
        guard let url = URL(string: AppConfig.baseURL + EndPoints.getProfile(userId: userId)) else { return }

        isLoading = true
        errorMessage = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(ProfileResponse.self, from: data)
            self.user = response.user
            saveProfileImageURLToUserDefaults(for: response.user)
        } catch {
            print("Profile fetch error:", error)
            errorMessage = "Could not load profile"
            user = nil
            UserDefaults.standard.set("", forKey: UserDefaultsKeys.profileImageURL)
        }

        isLoading = false
    }

    private func saveProfileImageURLToUserDefaults(for profileUser: ProfileUser) {
        guard let imagePath = profileUser.profileImage, !imagePath.isEmpty else {
            UserDefaults.standard.set("", forKey: UserDefaultsKeys.profileImageURL)
            return
        }
        let trimmed = imagePath.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("http") {
            UserDefaults.standard.set(trimmed, forKey: UserDefaultsKeys.profileImageURL)
            return
        }
        let path = trimmed.hasPrefix("/") ? String(trimmed.dropFirst()) : trimmed
        let base = AppConfig.profileImageBaseURL.hasSuffix("/") ? AppConfig.profileImageBaseURL : AppConfig.profileImageBaseURL + "/"
        let fullURL = base + path
        UserDefaults.standard.set(fullURL, forKey: UserDefaultsKeys.profileImageURL)
    }

    var profileImageURL: URL? {
        guard let user = user,
              let imagePath = user.profileImage,
              !imagePath.isEmpty else { return nil }
        let trimmed = imagePath.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("http") {
            return URL(string: trimmed)
        }
        let path = trimmed.hasPrefix("/") ? String(trimmed.dropFirst()) : trimmed
        let base = AppConfig.profileImageBaseURL.hasSuffix("/") ? AppConfig.profileImageBaseURL : AppConfig.profileImageBaseURL + "/"
        return URL(string: base + path)
    }

    /// Last path segment for API `profileImage` (e.g. `photo.jpg`), not a full URL.
    static func profileImageFilename(for pathOrURL: String?) -> String {
        guard let raw = pathOrURL?.trimmingCharacters(in: .whitespacesAndNewlines), !raw.isEmpty else {
            return ""
        }
        if let url = URL(string: raw), url.scheme != nil {
            return url.lastPathComponent
        }
        return (raw as NSString).lastPathComponent
    }

    /// `POST /profile/edit/{userId}` with JSON body `fullName`, `phone`, `profileImage`.
    func updateProfile(userId: String, fullName: String, phone: String, profileImageFilename: String) async -> Bool {
        guard !userId.isEmpty else {
            errorMessage = "Please sign in."
            return false
        }
        let trimmedName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter your name."
            return false
        }
        guard let url = URL(string: AppConfig.baseURL + EndPoints.editProfile(userId: userId)) else {
            errorMessage = "Invalid URL"
            return false
        }

        isSaving = true
        errorMessage = nil

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ProfileEditRequest(
            fullName: trimmedName,
            phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
            profileImage: profileImageFilename.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        do {
            request.httpBody = try JSONEncoder().encode(body)
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                isSaving = false
                return false
            }
            if (200...299).contains(http.statusCode) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let updated = try? decoder.decode(ProfileResponse.self, from: data) {
                    user = updated.user
                    saveProfileImageURLToUserDefaults(for: updated.user)
                } else {
                    await fetchProfile(userId: userId)
                }
                isSaving = false
                return true
            }
            if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let msg = obj["message"] as? String, !msg.isEmpty {
                errorMessage = msg
            } else {
                errorMessage = "Could not update profile."
            }
        } catch {
            errorMessage = "Could not update profile."
        }

        isSaving = false
        return false
    }
}
