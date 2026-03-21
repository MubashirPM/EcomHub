//
//  DeliveryAddressView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 18/02/26.
//

import SwiftUI

struct DeliveryAddressView: View {

    @AppStorage("userId") private var userId: String = ""
    @StateObject private var viewModel = DeliveryAddressViewModel()
    @State private var showAddAddress = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                if viewModel.isLoading && viewModel.addresses.isEmpty {
                    ProgressView()
                } else if let message = viewModel.errorMessage, viewModel.addresses.isEmpty {
                    VStack(spacing: 12) {
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.fetchAddresses(userId: userId) }
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.addresses) { address in
                                AddressCard(
                                    tag: address.defaultTag,
                                    title: address.title,
                                    address: address.displayAddress,
                                    isDefault: address.addressType?.lowercased() == "home"
                                )
                            }
                            Spacer(minLength: 100)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }

                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showAddAddress = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.custom)
                                .cornerRadius(14)
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Delivery address")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddAddress) {
                AddAddressView_()
                    .onDisappear {
                        Task { await viewModel.fetchAddresses(userId: userId) }
                    }
            }
            .onAppear {
                Task { await viewModel.fetchAddresses(userId: userId) }
            }
        }
    }
}

struct AddressCard: View {
    
    var tag: String?
    var title: String
    var address: String
    var isDefault: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if let tag = tag {
                Text(tag)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(address)
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray5))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DeliveryAddressView()
}
