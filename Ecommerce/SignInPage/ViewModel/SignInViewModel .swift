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
        
        print("🚨 signIn() STARTED")
            print("Using email:", email)
            print("Using password:", password)
        
       
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email address"
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Please Enter a valid email address"
            return
        }
        
        print("✅ Guard passed – building URL")
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
            print("Status Code:", httpResponse.statusCode)
            print("Raw Response:", String(data: data, encoding: .utf8) ?? "No data")
            
            if httpResponse.statusCode == 200 {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                if decoded.success {
                    self.user = decoded.user
                    
                    if let email = decoded.user?.email {
                           UserDefaults.standard.set(email, forKey: "userEmail")
                           print("Saved Email:", email)
                       }
                    
                    if let id = decoded.user?.id {
                          UserDefaults.standard.set(id, forKey: "userId")
                          print("Saved UserId:", id)
                      }
                    
                    print("Login success")
                    print("isLoggedIn before:", self.isLoggedIn)
                    self.isLoggedIn = true
                    print("isLoggedIn after:", self.isLoggedIn)
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
                return
            }
            
            try await sendTokenToBackend(idToken: idToken)
            
        } catch {
            print("Google Sign In Error:", error.localizedDescription)
        }
    }
    
    
    func sendTokenToBackend(idToken: String) async throws {
        
        guard let url = URL(string: "\(AppConfig.baseURL)/auth/google") else {
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["idToken": idToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                
                self.isLoggedIn = true
            }
            
        } catch {
            print("Backend error:", error.localizedDescription)
        }
    }
}
