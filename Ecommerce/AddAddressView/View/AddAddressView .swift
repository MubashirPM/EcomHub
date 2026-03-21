//
//  AddAddressView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 18/02/26.
//

import SwiftUI

struct AddAddressView_: View {

    @Environment(\.dismiss) private var dismiss
    @AppStorage("userId") private var userId: String = ""
    @StateObject private var viewModel = AddAddressViewModel()

    @State private var addressType = "home"
    @State private var fullName = ""
    @State private var phone = ""
    @State private var houseName = ""
    @State private var city = ""
    @State private var state = ""
    @State private var pincode = ""
    @State private var landMark = ""

    private let addressTypeOptions = ["home", "work", "other"]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        addressTypeField
                        fieldSection(title: "Full Name", text: $fullName)
                        fieldSection(title: "Phone", text: $phone)
                            .keyboardType(.phonePad)
                        fieldSection(title: "House Name", text: $houseName)
                        fieldSection(title: "City", text: $city)
                        fieldSection(title: "State", text: $state)
                        fieldSection(title: "Pincode", text: $pincode)
                            .keyboardType(.numberPad)
                        fieldSection(title: "Land Mark", text: $landMark)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }

                if let message = viewModel.errorMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                saveButton
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .onChange(of: viewModel.didSucceed) { _, succeeded in
                if succeeded { dismiss() }
            }
        }
    }

    private var header: some View {
        ZStack {
            Text("Add Address")
                .font(.headline)
                .foregroundColor(.black)

            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 16)
    }

    private var addressTypeField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Address Type")
                .font(.system(size: 15))
                .foregroundColor(.black)

            Picker("", selection: $addressType) {
                ForEach(addressTypeOptions, id: \.self) { option in
                    Text(option.capitalized).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private func fieldSection(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.black)

            TextField("", text: text)
                .padding()
                .background(Color(red: 0.85, green: 0.95, blue: 0.93))
                .foregroundColor(Color(red: 0.8, green: 0.3, blue: 0.3))
                .cornerRadius(8)
        }
    }

    private var saveButton: some View {
        Button(action: saveAddress) {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Save Address")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(red: 0.7, green: 0.25, blue: 0.25))
            .cornerRadius(8)
        }
        .disabled(viewModel.isLoading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private func saveAddress() {
        Task {
            await viewModel.addAddress(
                userId: userId,
                addressType: addressType,
                fullName: fullName,
                phone: phone,
                houseName: houseName,
                city: city,
                state: state,
                pincode: pincode,
                landMark: landMark
            )
        }
    }
}

#Preview {
    AddAddressView_()
}
