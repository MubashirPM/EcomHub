//
//  SignUpView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
import SwiftUI

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Background Image
                Image("SignUpImage")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity,
                           minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Sign up form card
                    VStack(spacing: 20) {
                        
                        Text("Sign up")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        // Full Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.subheadline)
                            
                            TextField("Enter Name",
                                      text: $viewModel.fullName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.gray.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email id")
                                .font(.subheadline)
                            
                            TextField("Enter Email",
                                      text: $viewModel.email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.gray.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                            
                            SecureField("Password",
                                        text: $viewModel.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.gray.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.subheadline)
                            
                            SecureField("Confirm Password",
                                        text: $viewModel.confirmPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.gray.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                        }
                        
                        // Error Message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                        
                        // Sign up button
                        Button {
                            Task{
                               await viewModel.signUp()
                            }
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Sign up")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .disabled(viewModel.isLoading)
                        .background(Color(red: 0.7, green: 0.2, blue: 0.2))
                        .cornerRadius(10)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $viewModel.isSignedUp) {
                OTPView()
            }
        }
    }
}
#Preview {
    SignUpView()
}
extension SignUpView {
    
    func inputField(title: String,
                    placeholder: String,
                    text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
            
            TextField(placeholder, text: text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    func secureField(title: String,
                     text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
            
            SecureField(title, text: text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
