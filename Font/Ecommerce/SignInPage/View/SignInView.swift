//
//  SignInView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//


import SwiftUI

struct SignInView: View {
    
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("signin")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    HStack {
                        FastionStore_()
                        Spacer()
                    }
                    .padding(.leading, 60)
                    
                    VStack(spacing: 20) {
                        
                        Text("Sign in")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        // Email
                        VStack(alignment: .leading) {
                            Text("Email id")
                            
                            TextField("Enter Email",
                                      text: $viewModel.email)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        // Password
                        VStack(alignment: .leading) {
                            Text("Password")
                            
                            SecureField("Password",
                                        text: $viewModel.password)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        // Error Message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                        
                        // Sign In Button
                        Button {
                            viewModel.signIn()
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Sign in")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(Color("CustomColor"))
                        .cornerRadius(12)
                        
                            
                    }
                    .padding()
                    .frame(maxWidth: 350, maxHeight: 450)
                    .background(Color.white)
                    .cornerRadius(30)
                }

                
            }
            
            
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                CustomTabBar()
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
