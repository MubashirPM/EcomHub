//
//  ProfileView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 14/02/26.
//

import SwiftUI

struct ProfileView: View {

    @AppStorage("userId") private var userId: String = ""
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                profileImageView
                VStack(alignment: .leading, spacing: 4) {
                    if viewModel.isLoading && viewModel.user == nil {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Text(viewModel.user?.fullName ?? "Guest")
                            .font(.subheadline)
                            .foregroundStyle(.black)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 30)
            
            VStack(spacing: 0) {
                NavigationLink(destination: OrdersView()){
                    AccountMenuItem(icon: "bag", title: "Orders")
                }
                
                Divider()
                    .padding(.horizontal,20)
                NavigationLink(destination: EditProfile(viewModel: viewModel)) {
                    AccountMenuItem(
                        icon: "person.text.rectangle",
                        title: "My Details"
                    )
                }
                
                Divider()
                    .padding(.horizontal, 20)
                
                NavigationLink(destination: DeliveryAddressView()){
                    AccountMenuItem(icon: "location", title: "Delivery Address")
                }
                
                Divider()
                    .padding(.horizontal, 20)
                
//                AccountMenuItem(icon: "creditcard", title: "Payment Methods")
                
//                Divider()
//                    .padding(.horizontal, 20)
                
//                AccountMenuItem(icon: "ticket", title: "Promo Cord")
                
//                Divider()
//                    .padding(.horizontal, 20)
                
                NavigationLink(destination: HelpView()){
                    AccountMenuItem(icon: "questionmark.circle", title: "Help")
                }
                
                Divider()
                    .padding(.horizontal, 20)
                
                NavigationLink(destination: AboutView()){
                    AccountMenuItem(icon: "info.circle", title: "About")
                }
            }
            .background(Color.white)
            
            Spacer()
            
            NavigationLink {
                SignInView()
            } label: {
                Text("Log Out")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.custom))
                    .cornerRadius(15)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
        .onAppear {
            if !userId.isEmpty {
                Task {
                    await viewModel.fetchProfile(userId: userId)
                }
            }
        }
    }
    
    @ViewBuilder
    private var profileImageView: some View {
        Group {
            if let url = viewModel.profileImageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "person.fill")
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                    case .empty:
                        ProgressView()
                            .tint(.white)
                    @unknown default:
                        Image(systemName: "person.fill")
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                    }
                }
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 35))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.pink, Color.orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .background(
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.pink.opacity(0.6), Color.orange.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
    
    
    struct AccountMenuItem: View {
        let icon: String
        let title: String
        
        var body: some View {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(.black)
                    .frame(width: 30)
                
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal,20)
            .padding(.vertical,15)
        }
    }
}
