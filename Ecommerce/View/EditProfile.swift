//
//  EditProfile.swift
//  Ecommerce
//
//  Created by Mubashir PM on 17/02/26.
//

import SwiftUI

struct EditProfile: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @AppStorage("userId") private var userId: String = ""

    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var email = ""

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                profilePhotoSection

                VStack(alignment: .leading, spacing: 18) {
                    CustomField(title: "Full Name", text: $fullName)
                    CustomField(title: "Phone Number", text: $phoneNumber)
                    CustomField(title: "Email", text: $email)
                }
                .padding(.horizontal)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.custom)
                        .cornerRadius(15)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle("My Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadProfileIntoFields()
        }
        .onChange(of: viewModel.user) { _, _ in
            loadProfileIntoFields()
        }
    }

    private var profilePhotoSection: some View {
        VStack(spacing: 10) {
            if let url = viewModel.profileImageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    @unknown default:
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            }
            Button {
                // TODO: Change profile photo (upload API)
            } label: {
                Text(" profile photo")
                    .foregroundStyle(.red)
                    .font(.subheadline)
            }
        }
        .padding(.top, 8)
    }

    private func loadProfileIntoFields() {
        if let user = viewModel.user {
            fullName = user.fullName
            phoneNumber = user.phone ?? ""
            email = user.email
        } else if !userId.isEmpty {
            Task {
                await viewModel.fetchProfile(userId: userId)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfile(viewModel: ProfileViewModel())
    }
}

struct CustomField: View {

    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)

            TextField("", text: $text)
                .padding()
                .background(Color.green.opacity(0.15))
                .cornerRadius(10)
        }
    }
}
