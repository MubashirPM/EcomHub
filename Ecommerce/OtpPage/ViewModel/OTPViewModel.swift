//
//  OTPViewModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 27/02/26.
//


import Foundation
import Combine

class OTPViewModel: ObservableObject {
    
    @Published var otpFields: [String] = ["", "", "", ""]
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isVerified = false
    
    func verifyOTP() {
        
        let otp = otpFields.joined()
        
        if otp.count != 4 {
            errorMessage = "Please enter complete OTP"
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            
            if otp == "1234" {
                self.isVerified = true
            } else {
                self.errorMessage = "Invalid OTP"
            }
        }
    }
    
    func resendOTP() {
        print("OTP Resent")
    }
}
