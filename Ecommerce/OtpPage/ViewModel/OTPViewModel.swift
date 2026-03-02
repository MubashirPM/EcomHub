//
//  OTPViewModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 27/02/26.
//


//import Foundation
//import Combine
//
//class OTPViewModel: ObservableObject {
//    
//    @Published var otpFields: [String] = ["", "", "", ""]
//    @Published var errorMessage: String?
//    @Published var isLoading = false
//    @Published var isVerified = false
//    @Published var successMessage: String?
//    
//    @MainActor
//    func verifyOTP(email: String, fullName: String, password: String) async {
//        
//        let otp = otpFields.joined()
//        
//        guard otp.count == 4 else {
//            errorMessage = "Please enter complete OTP"
//            return
//        }
//        
//        print("Email Sent:", email)
//        print("OTP Sent:", otp)
//        errorMessage = nil
//        isLoading = true
//        
//        do {
//            // Create URL
//            guard let url = URL(string: AppConfig.baseURL + EndPoints.Otp) else {
//                errorMessage = "Invalid URL"
//                isLoading = false
//                return
//            }
//            
//            
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            // Body
//            let body: [String: String] = [
//                "email": email,
//                   "otp": otp,
//                   "fullName": fullName,
//                   "password": password
//            ]
//            
//            request.httpBody = try JSONSerialization.data(withJSONObject: body)
//            
//            print("OTP Request Body:", body)
//            
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            
//            if let rawResponse = String(data: data, encoding: .utf8) {
//                print("Raw OTP Response:", rawResponse)
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                errorMessage = "Invalid response"
//                isLoading = false
//                return
//            }
//            
//            print("Status Code:", httpResponse.statusCode)
//            
//            if !(200...299).contains(httpResponse.statusCode) {
//                print("Server Error Response:",
//                      String(data: data, encoding: .utf8) ?? "No Data")
//                
//                errorMessage = "Server returned error \(httpResponse.statusCode)"
//                isLoading = false
//                return
//            }
//            
//            let decoded = try JSONDecoder().decode(OTPVerifyResponse.self, from: data)
//            
//            if let sucess = decoded.success, sucess == true {
//                print("OTP Verified Successfully")
//                isVerified = true
//                
//            } else if let error = decoded.error {
//                print("Backend Error:",error)
//                print("OTP Failed:", decoded.message)
//                errorMessage = error
//            } else {
//                errorMessage = decoded.message ?? "Something went Wrong"
//            }
//            
//        } catch {
//            print("OTP Network Error:", error.localizedDescription)
//            errorMessage = error.localizedDescription
//        }
//        
//        isLoading = false
//    }
//    
import Foundation
import SwiftUI
import Combine

class OTPViewModel: ObservableObject {
    
    @Published var otpFields: [String] = ["", "", "", ""]
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoading = false
    @Published var isVerified = false
    
    @MainActor
    func verifyOTP(email: String,
                   fullName: String,
                   password: String) async {
        
        let otp = otpFields.joined()
        
        // Validate OTP length
        guard otp.count == 4 else {
            errorMessage = "Please enter complete OTP"
            return
        }
        
        errorMessage = nil
        successMessage = nil
        isLoading = true
        
        do {
            // MARK: - Create URL
            guard let url = URL(string: AppConfig.baseURL + EndPoints.Otp) else {
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
            
            // MARK: - Create Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            
            // MARK: - Body
            let body: [String: String] = [
                "email": email,
                "otp": otp,
                "fullName": fullName,
                "password": password
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            print("OTP Request Body:", body)
            
            // MARK: - API Call
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid server response"
                isLoading = false
                return
            }
            
            print("Status Code:", httpResponse.statusCode)
            
            // MARK: - Handle Server Errors
            if !(200...299).contains(httpResponse.statusCode) {
                let serverMessage = String(data: data, encoding: .utf8) ?? ""
                print("Server Error Response:", serverMessage)
                errorMessage = "Server returned error \(httpResponse.statusCode)"
                isLoading = false
                return
            }
            
            // MARK: - Decode Response
            let decoded = try JSONDecoder().decode(OTPVerifyResponse.self,
                                                   from: data)
            
            if decoded.success == true {
                print("OTP Verified Successfully")
                
                successMessage = "Signup successful 🎉"
                
                // Delay navigation slightly for better UX
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    self.isVerified = true
                }
                
            } else {
                errorMessage = decoded.message ?? "OTP verification failed"
            }
            
        } catch {
            print("OTP Network Error:", error.localizedDescription)
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    @MainActor
    func resendOTP(email: String) async {
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            guard let url = URL(string: AppConfig.baseURL + "/resendOTP") else {
                errorMessage = "Invalid URL"
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: String] = [
                "email": email
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            print("Resend OTP Body:", body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                return
            }
            
            print("Resend Status Code:", httpResponse.statusCode)
            
            if let raw = String(data: data, encoding: .utf8) {
                print("Resend OTP Response:", raw)
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                errorMessage = "Failed to resend OTP"
            }
            
        } catch {
            print("Resend OTP Error:", error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
}



  
