//
//  CustomTabBar.swift
//  Ecommerce
//
//  Created by Mubashir PM on 12/02/26.
//
import SwiftUI

 
struct CustomTabBar: View {
    @State private var selectedTab = 0
    var body: some View {
       
        
        TabView (selection: $selectedTab) {
            NavigationStack {
                HomeScreenView_(selectedTab: $selectedTab)
            }
            .tabItem {
                Image(systemName: "square.grid.2x2")
                Text("Shop")
            }
            .tag(0)

            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Image(systemName: "safari")
                Text("Explore")
            }

            NavigationStack {
                CardView_()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Cart")
            }

            NavigationStack {
                FavouriteView()
            }
            .tabItem {
                Image(systemName: "heart")
                Text("Favourite")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                Text("Account")
            }
            .tag(1)
        }
        .accentColor(.red)
    }
}
