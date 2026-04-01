//
//  SignInViewModel .swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation
import SwiftUI
import Combine
import GoogleSignIn
import GoogleSignInSwift

@MainActor
class SignInViewModel: ObservableObject {
    
    // Inputs
    @Published var email: String = ""
    @Published var password: String = ""
    
    // MARK: - Outputs
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var user: User?
    
    // Email Login
    func signIn() async {

        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email address"
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }

        errorMessage = nil
        isLoading = true
        
        do {
            guard let url = URL(string: AppConfig.baseURL + EndPoints.signIn) else {
                print("URL:", AppConfig.baseURL + EndPoints.signIn)
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: String] = [
                "email": email,
                "password": password
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let config = URLSessionConfiguration.default
            config.httpCookieStorage = HTTPCookieStorage.shared
            let session = URLSession(configuration: config)
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Not an HTTP response")
                errorMessage = "Invalid response"
                isLoading = false
                return
            }
            if httpResponse.statusCode == 200 {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                if decoded.success {
                    self.user = decoded.user

                    if let access = decoded.accessToken, !access.isEmpty {
                        if let refresh = decoded.refreshToken, !refresh.isEmpty {
                            AuthTokenStore.save(accessToken: access, refreshToken: refresh)
                        } else {
                            AuthTokenStore.saveAccessToken(access)
                        }
                    }

                    if let email = decoded.user?.email {
                           UserDefaults.standard.set(email, forKey: "userEmail")
                           print("Saved Email:", email)
                       }
                    
                    if let id = decoded.user?.id {
                          UserDefaults.standard.set(id, forKey: "userId")
                      }

                    self.isLoggedIn = true
                } else {
                    switch decoded.code {
                           
                       case "INVALID_CREDENTIALS":
                           self.errorMessage = "Incorrect email or password."
                           
                       case "USER_NOT_FOUND":
                           self.errorMessage = "No account found with this email."
                        
                    case "ACCOUNT_BLOCKED":
                        errorMessage = "Your account is blocker. Contact support"
                           
                       default:
                           self.errorMessage = decoded.message ?? "Login failed. Please try again."
                       }
                }
                
            } else if httpResponse.statusCode == 401 {
                errorMessage = "Incorrect email or password."
            } else if httpResponse.statusCode == 404 {
                errorMessage = "Account not found."
            } else if httpResponse.statusCode >= 500 {
                errorMessage = "Server error. Please try again later."
            } else {
                errorMessage = "Something went wrong"
            }
            
        } catch {
            print("Decoding / API error:", error)
            if(error as? URLError)?.code == .notConnectedToInternet {
                errorMessage = "No internet connection "
            } else {
                errorMessage = "Unable to sign in. Please try again."
            }
        }
        
        isLoading = false
    }
    
    
    // Google Login
    func signInWithGoogle() async {
        
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            self.errorMessage = "Unable to get root view controller"
            return
        }
        
        isLoading = true
            errorMessage = nil
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: rootViewController
            )
            
            guard let idToken = result.user.idToken?.tokenString else {
                self.errorMessage = "Failed to get ID token"
                isLoading = false
                return
            }
            
            try await sendTokenToBackend(idToken: idToken)
            
        } catch {
            print("Google Sign In Error:", error.localizedDescription)
            errorMessage = "Google sign in failed."
        }
        isLoading = false
    }
    
    
    func sendTokenToBackend(idToken: String) async throws {

        guard let url = URL(string: "\(AppConfig.baseURL)/auth/google") else {
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["idToken": idToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(String(data: data, encoding: .utf8) ?? "")

            guard let httpResponse = response as? HTTPURLResponse else {
                isLoading = false
                return
            }

            if httpResponse.statusCode == 200 {
                extractAndSaveTokensIfPresent(from: data)
                let extracted = extractUserIdAndEmailFromGoogleResponse(data: data)
                if let userId = extracted.userId, !userId.isEmpty {
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.set("", forKey: UserDefaultsKeys.profileImageURL)
                    if let userEmail = extracted.email {
                        UserDefaults.standard.set(userEmail, forKey: "userEmail")
                    }
                    self.isLoggedIn = true
                } else {
                    errorMessage = "Could not get user from Google sign in. Please try again."
                }
            } else {
                errorMessage = "Google sign in failed. Please try again."
            }
        } catch {
            print("Backend error:", error.localizedDescription)
            errorMessage = "Unable to sign in with Google."
        }
        isLoading = false
    }

    private func extractAndSaveTokensIfPresent(from data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
        var access = (json["accessToken"] as? String) ?? (json["access_token"] as? String)
        var refresh = (json["refreshToken"] as? String) ?? (json["refresh_token"] as? String)
        if access == nil || refresh == nil, let dataDict = json["data"] as? [String: Any] {
            if access == nil {
                access = (dataDict["accessToken"] as? String) ?? (dataDict["access_token"] as? String)
            }
            if refresh == nil {
                refresh = (dataDict["refreshToken"] as? String) ?? (dataDict["refresh_token"] as? String)
            }
        }
        if let a = access, !a.isEmpty {
            if let r = refresh, !r.isEmpty {
                AuthTokenStore.save(accessToken: a, refreshToken: r)
            } else {
                AuthTokenStore.saveAccessToken(a)
            }
        }
    }

    /// Tries decoded AuthResponse first, then falls back to raw JSON for common backend shapes.
    private func extractUserIdAndEmailFromGoogleResponse(data: Data) -> (userId: String?, email: String?) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        if let authResponse = try? decoder.decode(AuthResponse.self, from: data),
           let user = authResponse.user {
            return (user.id, user.email)
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return (nil, nil)
        }

        var userId: String?
        var email: String?

        func stringFrom(_ value: Any?) -> String? {
            if let s = value as? String, !s.isEmpty { return s }
            if let n = value as? Int { return String(n) }
            if let n = value as? NSNumber { return n.stringValue }
            return nil
        }

        userId = stringFrom(json["userId"]) ?? stringFrom(json["user_id"]) ?? stringFrom(json["id"]) ?? stringFrom(json["_id"])

        if let userDict = json["user"] as? [String: Any] {
            if userId == nil { userId = stringFrom(userDict["_id"]) ?? stringFrom(userDict["id"]) ?? stringFrom(userDict["user_id"]) }
            if email == nil, let e = userDict["email"] as? String { email = e }
        }

        if let dataDict = json["data"] as? [String: Any] {
            if userId == nil { userId = stringFrom(dataDict["_id"]) ?? stringFrom(dataDict["id"]) ?? stringFrom(dataDict["userId"]) ?? stringFrom(dataDict["user_id"]) }
            if email == nil, let e = dataDict["email"] as? String { email = e }
            if userId == nil, let userDict = dataDict["user"] as? [String: Any] {
                userId = stringFrom(userDict["_id"]) ?? stringFrom(userDict["id"]) ?? stringFrom(userDict["user_id"])
                if email == nil, let e = userDict["email"] as? String { email = e }
            }
        }

        if email == nil, let e = json["email"] as? String { email = e }

        return (userId, email)
    }
}
