//
//  AboutView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 18/02/26.
//


import SwiftUI


struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    
                    VStack(spacing: -8) {
                        HStack(spacing: 0) {
                            Text("F")
                                .font(.custom("Pacifico-Regular", size: 50))
                                .foregroundStyle(.red)
                            
                            Text("ashion")
                                .font(.custom("Pacifico-Regular", size: 50))
                                .foregroundColor(.black)
                        }
                        Text("Store")
                            .font(.custom("Pacifico-Regular", size: 50))
                            .foregroundColor(.black)
                    }
                    .padding(.top, 40)
                    
                    // Version
                    Text("Version 1.2.3")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                    
                    // App Description
                    Text("Your Ultimate Fashion Destination")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 32)
                    
                    // Company Info
                    VStack(spacing: 12) {
                        Text("Developed by Innovatech Solutions")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        
                        Text("123 Innovation Drive, Tech City, CA 90210")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        
                        Text("support@innovatech.com")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.7, green: 0.25, blue: 0.25))
                    }
                    .padding(.top, 32)
                    
                    // Legal Links
                    VStack(spacing: 16) {
                        Button(action: {
                            // Terms action
                        }) {
                            Text("Terms & Conditions")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0.7, green: 0.25, blue: 0.25))
                        }
                        
                        Button(action: {
                            // Privacy action
                        }) {
                            Text("Privacy Policy")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0.7, green: 0.25, blue: 0.25))
                        }
                    }
                    .padding(.top, 32)
                    
                    // Footer
                    Text("© 2026 Fashion Store")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                        .padding(.bottom, 32)
                }
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.black)
//                            .font(.system(size: 20))
//                    }
//                }
                
                ToolbarItem(placement: .principal) {
                    Text("About")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
