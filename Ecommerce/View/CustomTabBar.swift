//
//  CustomTabBar.swift
//  Ecommerce
//
//  Created by Mubashir PM on 12/02/26.
//
import SwiftUI

 
struct CustomTabBar: View {
    @State private var selectedTab = 0
    @AppStorage("userId") var userId: String = ""
    @StateObject private var wishlistVM = WishlistViewModel()
    @StateObject private var profileVM = ProfileViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeScreenView_(userId: userId, selectedTab: $selectedTab)
            }
            .tabItem {
                Image(systemName: "square.grid.2x2")
                Text("Shop")
            }
            .tag(0)

            NavigationStack {
                ExploreView(selectedTab: $selectedTab)
            }
            .tabItem {
                Image(systemName: "safari")
                Text("Explore")
            }
            .tag(1)

            NavigationStack {
                CartView()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Cart")
            }
            .tag(2)

            NavigationStack {
                FavouriteView()
            }
            .tabItem {
                Image(systemName: "heart")
                Text("Favourite")
            }
            .tag(3)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                Text("Account")
            }
            .tag(4)
        }
        .environmentObject(wishlistVM)
        .environmentObject(profileVM)
        .accentColor(.custom)
        .onAppear {
            if !userId.isEmpty {
                Task {
                    await profileVM.fetchProfile(userId: userId)
                }
            }
        }
    }
}
