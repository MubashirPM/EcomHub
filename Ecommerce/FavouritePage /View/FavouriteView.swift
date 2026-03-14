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
                                        FavouriteProductCard(product: product)
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

private struct FavouriteProductCard: View {

    let product: HomeProduct

    private var imageURL: URL? {
        guard let first = product.productImage.first, !first.isEmpty else { return nil }
        let trimmed = first.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("http") {
            return URL(string: trimmed)
        }
        let path = trimmed.hasPrefix("/") ? String(trimmed.dropFirst()) : trimmed
        let full = AppConfig.imageBaseURL.hasSuffix("/") ? AppConfig.imageBaseURL + path : AppConfig.imageBaseURL + "/" + path
        return URL(string: full)
    }

    var body: some View {
        VStack(spacing: 8) {
            Group {
                if let url = imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            Image("ErrorImage")
                                .resizable()
                                .scaledToFit()
                        case .empty:
                            ProgressView()
                        @unknown default:
                            ProgressView()
                        }
                    }
                } else {
                    Image("ErrorImage")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(height: 140)
            .clipped()
            .cornerRadius(12)
            Text(product.productName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Text("Rs. \(product.salePrice, specifier: "%.0f")")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.custom)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}
