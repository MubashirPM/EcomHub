//
//  RazorpaySamplePayView.swift
//  Ecommerce
//

import SwiftUI

/// Beginner-friendly sample screen to test Razorpay checkout directly.
struct RazorpaySamplePayView: View {
    @StateObject private var paymentViewModel = CheckoutPaymentViewModel()

    @State private var userId = ""
    @AppStorage("selectedAddressId") private var selectedAddressId = ""
    @State private var amountText = "499"
    @State private var email = ""
    @State private var contact = ""
    @State private var isBuyNow = false

    var body: some View {
        Form {
            Section("Payment Details") {
                TextField("User ID", text: $userId)
                TextField("Selected Address ID", text: $selectedAddressId)
                TextField("Amount", text: $amountText)
                    .keyboardType(.numberPad)
                TextField("Email (prefill)", text: $email)
                    .keyboardType(.emailAddress)
                TextField("Contact (prefill)", text: $contact)
                    .keyboardType(.phonePad)
                Toggle("Is Buy Now", isOn: $isBuyNow)
            }

            Section {
                Button("Pay with Razorpay") {
                    let amount = Int(amountText) ?? 0
                    Task {
                        await paymentViewModel.startPayment(
                            userId: userId,
                            amount: amount,
                            selectedAddressId: selectedAddressId,
                            isBuyNow: isBuyNow,
                            prefillEmail: email,
                            prefillContact: contact
                        )
                    }
                }
                .disabled(paymentViewModel.isLoading)

                if paymentViewModel.isLoading {
                    ProgressView("Processing...")
                }
                if let error = paymentViewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
                if let success = paymentViewModel.successMessage {
                    Text(success).foregroundColor(.green)
                }
            }
        }
        .navigationTitle("Razorpay Sample")
    }
}

#Preview {
    NavigationStack {
        RazorpaySamplePayView()
    }
}
