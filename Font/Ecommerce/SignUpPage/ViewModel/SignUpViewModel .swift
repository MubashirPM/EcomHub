//
//  SignUpViewModel .swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation
import SwiftUI
import Combine


@MainActor
class SignUpViewModel : ObservableObject {
    
    @Published var fullName : String = ""
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var confirmPassword : String = ""
    
    
    @Published var errorMessage : String?
    @Published var isLoading : Bool = false
    @Published var isSignedUp : Bool = false
    
    func signUp() async {
        
        // Validation
        guard !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Enter a valid email"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be atleast 6 characters"
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        do {
            // Create URL
            guard let url = URL(string: AppConfig.baseURL + "/signup") else {
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
            
            // Create Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Body
            let body: [String: String] = [
                "fullName": fullName,
                "email": email,
                "password": password,
                "confirmPassword": confirmPassword
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            // API Call
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                isLoading = false
                return
            }
            
            // Decode backend response (if JSON)
            if httpResponse.statusCode == 200 {
                isSignedUp = true
            } else {
                if let errorData = String(data: data, encoding: .utf8) {
                    errorMessage = errorData
                } else {
                    errorMessage = "Signup failed"
                }
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    }

