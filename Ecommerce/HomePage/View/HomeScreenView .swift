
//
//  HomeScreenView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 12/02/26.
//

import SwiftUI

struct HomeScreenView_: View {

    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var wishlistVM: WishlistViewModel
    let userId: String

    @Binding var selectedTab: Int
    @State private var navigateToSearch = false
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Color(.custom)
                .ignoresSafeArea()
            
            VStack(spacing: 5) {
                
                // MARK: Header + Search
                VStack(spacing: 0) {

                    HStack {
                        FastionStore_()
                            .font(.title3)

                        Spacer()

                        Button {
                            selectedTab = 4
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.yellow)
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding(.horizontal, 20)

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search Item",
                                  text: $viewModel.searchText)
                        .foregroundColor(.black)
                        .submitLabel(.search)
                        .onSubmit {
                            if !viewModel.searchText.isEmpty {
                                navigateToSearch = true
                            }
                        }

                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }

                .padding(.top, -10)
                
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .ignoresSafeArea(edges: .bottom)
                    
                    // Content
                    ScrollView {
                        
                        VStack(spacing: 20) {
                            
                            VStack(alignment: .leading) {
                                Text("Welcome to,")
                                    .font(.custom("Pacifico-Regular", size: 28))
                                
                                HStack(spacing: 8) {
                                    Text("Our")
                                    Text("Fashion")
                                        .foregroundColor(Color.custom
                                        )
                                    Text("Store")
                                        .foregroundColor(.gray)
                                }
                                .font(.custom("Pacifico-Regular", size: 28))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            //                         New Arrivals Banner
                            ZStack(alignment: .leading) {
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.black)
                                    .frame(height: 130)   // reduced from 180
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    Text("NEW ARRIVALS 👕")
                                        .font(
                                            .headline
                                        )   // smaller than title2
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Latest styles in Shirts & T-Shirts")
                                        .font(.caption)    // smaller
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    NavigationLink {
                                        NewArrivalsview_(wishlistVM: wishlistVM)
                                            .environmentObject(wishlistVM)
                                    } label: {
                                        Text("Shop Now")
                                            .font(
                                                .caption2
                                            )   // smaller button text
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.white)
                                            .cornerRadius(15)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(.leading, 20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 15)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Text("Trending")
                                        .font(.headline)
                                        .bold()
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                ScrollView(
                                    .horizontal,
                                    showsIndicators: false
                                ) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.filteredTrending) { product in
                                            ZStack(alignment: .topTrailing) {
                                                NavigationLink(destination: DetailsPageView(product: product, wishlistVM: wishlistVM)) {
                                                    ProductsCardContent(product: product)
                                                }
                                                WishlistHeartButton(productId: product.id, userId: userId)
                                            }
                                        }
                                        if viewModel.searchText != "" && viewModel.filteredNewArrivals.isEmpty {
                                            Text("No products found")
                                                .foregroundColor(.gray)
                                                .padding()
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 6)
                                }
                            }
                            // MARK: New Arrivals Section
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Text("New Arrivals")
                                        .font(.headline)
                                        .bold()
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                ScrollView(
                                    .horizontal,
                                    showsIndicators: false
                                ) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.filteredNewArrivals) { product in
                                            ZStack(alignment: .topTrailing) {
                                                NavigationLink(destination: DetailsPageView(product: product, wishlistVM: wishlistVM)) {
                                                    ProductsCardContent(product: product)
                                                        .padding(.vertical, 5)
                                                }
                                                WishlistHeartButton(productId: product.id, userId: userId)
                                            }
                                        }
                                        if viewModel.searchText != "" && viewModel.filteredNewArrivals.isEmpty {
                                            Text("No products found")
                                                .foregroundColor(.gray)
                                                .padding()
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Text("Premium")
                                        .font(.headline)
                                        .bold()
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                ScrollView(
                                    .horizontal,
                                    showsIndicators: false
                                ) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.filteredFeatured) { product in
                                            ZStack(alignment: .topTrailing) {
                                                NavigationLink(destination: DetailsPageView(product: product, wishlistVM: wishlistVM)) {
                                                    ProductsCardContent(product: product)
                                                        .padding(.vertical, 5)
                                                }
                                                WishlistHeartButton(productId: product.id, userId: userId)
                                            }
                                        }
                                        if viewModel.searchText != "" && viewModel.filteredNewArrivals.isEmpty {
                                            Text("No products found")
                                                .foregroundColor(.gray)
                                                .padding()
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.top,10)
                        .padding(.bottom,80)
                    }
                }
                .background(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                )
            }
            
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            viewModel.fetchHomeData()
            if !userId.isEmpty {
                Task {
                    await wishlistVM.fetchWishlist(userId: userId)
                }
            }
        }
    }
}

/// Card content only (image, name, price). Use with WishlistHeartButton in a ZStack so heart tap doesn’t trigger NavigationLink.
struct ProductsCardContent: View {
    let product: HomeProduct

    var body: some View {
        VStack(spacing: 8) {
            if let firstImage = product.productImage.first {
                let fullURL = AppConfig.imageBaseURL + firstImage
                AsyncImage(url: URL(string: fullURL)) { image in
                    image.resizable().scaledToFit()
                } placeholder: { ProgressView() }
                .frame(width: 159, height: 146)
                .clipped()
                .cornerRadius(18)
            }
            VStack(spacing: 4) {
                Text(product.productName)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.black)
                    .lineLimit(2)
                Text("Rs. \(product.salePrice, specifier: "%.0f")")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.custom)
            }
        }
    }
}

/// Heart button for wishlist; use on top of card in ZStack so tap doesn’t trigger NavigationLink.
struct WishlistHeartButton: View {
    @EnvironmentObject private var wishlistVM: WishlistViewModel
    let productId: String
    let userId: String

    var body: some View {
        Button {
            guard !userId.isEmpty else { return }
            Task {
                await wishlistVM.addToWishlist(userId: userId, productId: productId)
            }
        } label: {
            Image(systemName: wishlistVM.isFavorite(productId: productId) ? "heart.fill" : "heart")
                .foregroundColor(.black)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(10)
    }
}

/// Full card with heart; use when you don’t need NavigationLink (e.g. in a list that isn’t a link).
struct ProductsCard: View {
    let product: HomeProduct
    @EnvironmentObject var wishlistVM: WishlistViewModel
    let userId: String

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ProductsCardContent(product: product)
            WishlistHeartButton(productId: product.id, userId: userId)
        }
    }
}
