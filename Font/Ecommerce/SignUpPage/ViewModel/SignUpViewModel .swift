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
    
    func signUp() {
        
        guard !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Enter a vail email"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be atleast 6 character"
            return
        }
        errorMessage = nil
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                    self.isSignedUp = true
                }
    }
}
