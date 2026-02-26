//
//  SignInViewModel .swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class SignInViewModel: ObservableObject {
    
    // MARK: - Inputs
    @Published var email: String = ""
    @Published var password: String = ""
    
    // MARK: - Outputs
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    
    @Published var user: User?
    
    // MARK: - Email Login
    func signIn() {
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and Password are required."
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.user = User(
                id: 1,
                name: "Email User",
                email: self.email,
                token: "email_token"
            )
            
            self.isLoading = false
            self.isLoggedIn = true
        }
    }
    
    // MARK: - Google Login
    func signInWithGoogle() {
        
        isLoading = true
        errorMessage = nil
        
        // Simulate Google API Login
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.user = User(
                id: 2,
                name: "Google User",
                email: "googleuser@gmail.com",
                token: "google_token_123"
            )
            
            self.isLoading = false
            self.isLoggedIn = true
        }
    }
}
