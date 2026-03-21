//
//  FavouriteView.swift
//  Ecommerce
//
//

import SwiftUI

struct FavouriteView: View {

    @AppStorage("userId") private var userId: String = ""
    @EnvironmentObject private var wishlistVM: WishlistViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color(.custom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("My Favourites")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)

                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .ignoresSafeArea(edges: .bottom)

                    if userId.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("Sign in to see favourites")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Your wishlist will appear here.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 60)
                    } else if wishlistVM.isLoading && wishlistVM.wishlistProducts.isEmpty {
                        ProgressView()
                            .padding(.top, 60)
                    } else if wishlistVM.wishlistProducts.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "heart")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No favourites yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Tap the heart on products to add them here.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 60)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(wishlistVM.wishlistProducts) { product in
                                    NavigationLink(destination: DetailsPageView(product: product, wishlistVM: wishlistVM)) {
                                        ProductsCardContent(product: product)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                            .padding(.bottom, 80)
                        }
                    }
                }
            }
        }
        .onAppear {
            if !userId.isEmpty {
                Task {
                    await wishlistVM.fetchWishlist(userId: userId)
                }
            }
        }
    }
}
