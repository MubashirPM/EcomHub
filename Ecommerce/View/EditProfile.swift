//
//  EditProfile.swift
//  Ecommerce
//
//  Created by Mubashir PM on 17/02/26.
//

import SwiftUI

struct EditProfile: View {
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var dateOfBirth = ""
    @State private var gender = ""
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
//                HStack {
//                    NavigationLink {
////                        customta
//                    } label: {
//                        Image(systemName: "arrow.left")
//                            .font(.title3)
//                            .foregroundStyle(.black)
//                            .padding()
//                    }
//
//                    Spacer()
//                    
//                    Image(systemName: "arrow left")
//                        .opacity(0)
//                }
//                .padding(.horizontal)
//                .padding(.top)
                
                VStack(spacing: 10) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80,height: 80)
                        .clipShape(Circle())
                    Button {
                        
                    } label: {
                        Text("Change profile photo")
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                }
                VStack(alignment: .leading, spacing: 18) {
                                   
                    CustomField(title: "Full Name", text: $fullName)
                    CustomField(title: "Phone Number", text: $phoneNumber)
                    CustomField(title: "Email", text: $email)
                    CustomField(title: "Date of Birth", text: $dateOfBirth)
                    CustomField(title: "Gender", text: $gender)
                }
                .padding(.horizontal)
                Spacer()
                Button {
                    print("Save Changes")
                } label: {
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.custom)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                Button {
                    NavigationLink("", destination: ProfileView())
                } label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                
                Spacer()
            }
//            .navigationBarBackButtonHidden(true)
//            .toolbar(.hidden,for: .navigationBar)
        }
    }
}

#Preview {
    EditProfile()
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
