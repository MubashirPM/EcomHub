//
//  OTPView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 27/02/26.
//


import SwiftUI

struct OTPView: View {
    
    @StateObject private var viewModel = OTPViewModel()
    @FocusState private var focusedField: Int?
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("OTP Verification")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Enter the 4 digit code sent to your email")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            // OTP Boxes
            HStack(spacing: 15) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: $viewModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .frame(width: 55, height: 60)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .focused($focusedField, equals: index)
                        .onChange(of: viewModel.otpFields[index]) { newValue in
                            
                            if newValue.count == 1 {
                                if index < 3 {
                                    focusedField = index + 1
                                }
                            }
                            
                            if newValue.count > 1 {
                                viewModel.otpFields[index] = String(newValue.prefix(1))
                            }
                        }
                }
            }
            
            // Error
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            // Verify Button
            Button {
                viewModel.verifyOTP()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Verify")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color("CustomColor"))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Resend
            Button("Resend OTP") {
                viewModel.resendOTP()
            }
            .font(.footnote)
            .foregroundColor(Color("CustomColor"))
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    OTPView()
}
