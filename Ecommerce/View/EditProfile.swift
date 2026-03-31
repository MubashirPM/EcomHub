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
    /// Filename for `profileImage` in `POST /profile/edit/{userId}` (e.g. from existing profile).
    @State private var profileImageFilename = ""

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                profilePhotoSection

                VStack(alignment: .leading, spacing: 18) {
                    CustomField(title: "Full Name", text: $fullName)
                    CustomField(title: "Phone Number", text: $phoneNumber)
                    emailReadOnlySection
                }
                .padding(.horizontal)

                if let err = viewModel.errorMessage {
                    Text(err)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                Button {
                    Task {
                        let ok = await viewModel.updateProfile(
                            userId: userId,
                            fullName: fullName,
                            phone: phoneNumber,
                            profileImageFilename: profileImageFilename
                        )
                        if ok {
                            dismiss()
                        }
                    }
                } label: {
                    Group {
                        if viewModel.isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Save")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.custom)
                    .foregroundStyle(.white)
                    .cornerRadius(15)
                }
                .disabled(viewModel.isSaving || userId.isEmpty)
                .padding(.horizontal)

                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
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

    private var emailReadOnlySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Email")
                .font(.subheadline)
            Text(email.isEmpty ? "—" : email)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.15))
                .cornerRadius(10)
                .foregroundStyle(.primary)
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
        }
        .padding(.top, 8)
    }

    private func loadProfileIntoFields() {
        if let user = viewModel.user {
            fullName = user.fullName
            phoneNumber = user.phone ?? ""
            email = user.email
            profileImageFilename = ProfileViewModel.profileImageFilename(for: user.profileImage)
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
