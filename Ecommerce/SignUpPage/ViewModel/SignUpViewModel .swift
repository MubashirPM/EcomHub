//
//  SignUpViewModel .swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation
import SwiftUI
import Combine

/// Backend sign-up error response (success: false, message, code).
struct SignUpErrorResponse: Decodable {
    let success: Bool?
    let message: String?
    let code: String?
}

@MainActor
class SignUpViewModel: ObservableObject {

    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isSignedUp = false

    func signUp() async {

        // Validation
        guard !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        guard fullName.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 else {
            errorMessage = "Please enter a valid full name."
            return
        }

        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        errorMessage = nil
        isLoading = true

        do {
            guard let url = URL(string: AppConfig.baseURL + EndPoints.signUp) else {
                errorMessage = "Something went wrong. Please try again."
                isLoading = false
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: String] = [
                "fullName": fullName.trimmingCharacters(in: .whitespacesAndNewlines),
                "email": email.trimmingCharacters(in: .whitespacesAndNewlines),
                "password": password,
                "confirmPassword": confirmPassword
            ]
            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response. Please try again."
                isLoading = false
                return
            }

            if httpResponse.statusCode == 201 {
                isSignedUp = true
            } else {
                errorMessage = signUpErrorMessage(from: data, statusCode: httpResponse.statusCode)
            }
        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                errorMessage = "No internet connection. Please check your network and try again."
            } else {
                errorMessage = "Unable to sign up. Please try again later."
            }
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }

        isLoading = false
    }

    /// Maps backend response or status code to a user-friendly error message.
    private func signUpErrorMessage(from data: Data, statusCode: Int) -> String {
        if let decoded = try? JSONDecoder().decode(SignUpErrorResponse.self, from: data) {
            if let code = decoded.code?.uppercased() {
                switch code {
                case "USER_ALREADY_EXISTS", "EMAIL_ALREADY_EXISTS", "EMAIL_EXISTS":
                    return "An account with this email already exists. Please sign in or use a different email."
                case "INVALID_EMAIL":
                    return "Please enter a valid email address."
                case "WEAK_PASSWORD":
                    return "Password is too weak. Use at least 6 characters."
                case "PASSWORDS_DO_NOT_MATCH":
                    return "Passwords do not match."
                default:
                    break
                }
            }
            if let message = decoded.message, !message.isEmpty {
                return message
            }
        }
        switch statusCode {
        case 400:
            return "Invalid request. Please check your details and try again."
        case 409:
            return "An account with this email already exists. Please sign in or use a different email."
        case 422:
            return "Invalid data. Please check your details and try again."
        case 500...599:
            return "Server error. Please try again later."
        default:
            return "Sign up failed. Please try again."
        }
    }
}

