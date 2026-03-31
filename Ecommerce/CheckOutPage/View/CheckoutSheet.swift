//
//  CheckoutSheet.swift
//  Ecommerce
//
//  Created by Mubashir PM on 14/02/26.
//

import SwiftUI

struct CheckoutSheet: View {
    let totalPrice: Int
    @Binding var isPresented: Bool

    @AppStorage("userId") private var userId: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    @AppStorage("userPhone") private var userPhone: String = ""
    @AppStorage("selectedAddressId") private var selectedAddressId: String = ""
    @StateObject private var paymentViewModel = CheckoutPaymentViewModel()
    @StateObject private var addressViewModel = DeliveryAddressViewModel()
    @State private var showDeliveryAddress = false
    @State private var initialAddressLoadDone = false
    /// Keep false for regular cart checkout. Set true for buy-now flow.
    var isBuyNow: Bool = false
    /// Optional payload for buy-now product.
    var buyNowProduct: BuyNowProductPayload? = nil
    /// Called after server payment verification succeeds; use to show order confirmation (e.g. full-screen).
    var onPaymentVerified: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Checkout")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                        .bold()
                }
            }
            .padding(.horizontal,20)
            .padding(.top,20)
            .padding(.bottom,20)
            
            HStack {
                Text("Payment")
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Image(systemName: "creditcard.fill")
                    .foregroundStyle(.red)
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal,20)
            .padding(.vertical,15)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(10)
            .padding(.horizontal,20)
            .padding(.bottom,15)
            
            Button {
                showDeliveryAddress = true
            } label: {
                HStack {
                    Text("Address")
                        .foregroundStyle(.gray)

                    Spacer()

                    Text(addressSubtitle)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.trailing)

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)

            if initialAddressLoadDone, selectedAddressId.isEmpty, !userId.isEmpty,
               addressViewModel.addresses.isEmpty {
                Text("Add a delivery address to place your order. Tap Address above.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
            }
            
            HStack {
                Text("Total Cost")
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Rs.\(displayedCheckoutTotal)")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            HStack(spacing: 4) {
                Text("By placing an order you agree to our")
                    .font(.caption)
                    .foregroundColor(.gray)
                           
                Text("Terms")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                           
                Text("And")
                    .font(.caption)
                    .foregroundColor(.gray)
                           
                Text("Conditions")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Button {
                Task {
                    await paymentViewModel.startPayment(
                        userId: userId,
                        amount: totalPrice,
                        selectedAddressId: selectedAddressId,
                        isBuyNow: isBuyNow,
                        prefillEmail: userEmail,
                        prefillContact: userPhone,
                        buyNowProduct: buyNowProduct
                    )
                }
            } label: {
                if paymentViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.custom)
                        .cornerRadius(15)
                } else {
                    Text("Place Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.custom)
                        .cornerRadius(15)
                }
            }
            .disabled(paymentViewModel.isLoading)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            if let errorMessage = paymentViewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }

            if let successMessage = paymentViewModel.successMessage {
                Text(successMessage)
                    .font(.footnote)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }
        }
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.2), radius: 20)
        .sheet(isPresented: $showDeliveryAddress) {
            DeliveryAddressView(dismissOnSelect: true)
        }
        .onAppear {
            paymentViewModel.payableTotalRupees = nil
            Task { await syncCheckoutAddressIfNeeded() }
        }
        .onChange(of: showDeliveryAddress) { _, isShowing in
            if !isShowing {
                Task { await syncCheckoutAddressIfNeeded() }
            }
        }
        .onChange(of: paymentViewModel.paymentVerificationSucceeded) { _, succeeded in
            guard succeeded else { return }
            paymentViewModel.paymentVerificationSucceeded = false
            isPresented = false
            onPaymentVerified?()
        }
    }

    /// Cart subtotal until create-order returns; then server total (tax/shipping included).
    private var displayedCheckoutTotal: Int {
        paymentViewModel.payableTotalRupees ?? totalPrice
    }

    private var addressSubtitle: String {
        if !selectedAddressId.isEmpty {
            return "Address selected"
        }
        return "Pick an address"
    }

    /// Loads saved addresses and auto-selects home (or first) when nothing is selected yet.
    private func syncCheckoutAddressIfNeeded() async {
        guard !userId.isEmpty else {
            initialAddressLoadDone = true
            return
        }
        await addressViewModel.fetchAddresses(userId: userId)
        if selectedAddressId.isEmpty {
            let list = addressViewModel.addresses
            let pick = list.first(where: { $0.addressType?.lowercased() == "home" }) ?? list.first
            if let pick {
                selectedAddressId = pick.id
            }
        }
        initialAddressLoadDone = true
    }
}


#Preview {
    CheckoutSheet(totalPrice: 1297, isPresented: .constant(true))
}
