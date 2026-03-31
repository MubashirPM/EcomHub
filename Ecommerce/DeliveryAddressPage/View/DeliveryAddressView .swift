//
//  DeliveryAddressView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 18/02/26.
//

import SwiftUI

struct DeliveryAddressView: View {

    /// When `true` (e.g. checkout sheet), dismisses after the user picks an address.
    var dismissOnSelect: Bool = false

    @AppStorage("userId") private var userId: String = ""
    @AppStorage("selectedAddressId") private var selectedAddressId: String = ""
    @StateObject private var viewModel = DeliveryAddressViewModel()
    @State private var showAddAddress = false
    @Environment(\.dismiss) private var dismiss

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
                    VStack(spacing: 0) {
                        if let message = viewModel.errorMessage, !viewModel.addresses.isEmpty {
                            Text(message)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                        List {
                            ForEach(viewModel.addresses) { address in
                                AddressCard(
                                    tag: address.defaultTag,
                                    title: address.title,
                                    address: address.displayAddress,
                                    isDefault: address.addressType?.lowercased() == "home",
                                    isSelected: selectedAddressId == address.id,
                                    isDeleting: viewModel.deletingAddressId == address.id
                                )
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedAddressId = address.id
                                    if dismissOnSelect {
                                        dismiss()
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        Task {
                                            await viewModel.deleteAddress(userId: userId, addressId: address.id)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            
                                    }
                                    
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .safeAreaInset(edge: .bottom, spacing: 0) {
                            Color.clear.frame(height: 88)
                        }
                        .frame(maxWidth: .infinity)
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
    var isSelected: Bool = false
    var isDeleting: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            if let tag = tag {
                Text(tag)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }

            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.custom)
                }
            }

            Text(address)
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray5))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.custom : Color.clear, lineWidth: 2)
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay {
            if isDeleting {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.15))
                ProgressView()
                    .tint(Color.custom)
            }
        }
    }
}

#Preview {
    DeliveryAddressView()
}
