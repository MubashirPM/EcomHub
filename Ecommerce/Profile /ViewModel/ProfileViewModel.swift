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
    @Published var errorMessage: String?

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
}
