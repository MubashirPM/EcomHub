
//
//  HomeScreenView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 12/02/26.
//

import SwiftUI

struct HomeScreenView_: View {
    
    @StateObject private var viewModel = HomeViewModel()
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
                            selectedTab = 1
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
                                        .font(.headline)   // smaller than title2
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Latest styles in Shirts & T-Shirts")
                                        .font(.caption)    // smaller
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    NavigationLink(
                                        destination: NewArrivalsview_()
                                    ) {
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
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.filteredTrending) { product in
                                            NavigationLink(destination: DetailsPageView(product: product)) {
                                                ProductsCard(product: product)
                                            }
                                        }
                                        if viewModel.searchText != "" && viewModel.filteredNewArrivals.isEmpty {
                                            Text("No products found")
                                                .foregroundColor(.gray)
                                                .padding()
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical,6)
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
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.filteredNewArrivals) { product in
                                            NavigationLink(destination: DetailsPageView(product: product)) {
                                                ProductsCard(product: product)
                                                    .padding(.vertical,5)
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
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.filteredFeatured) { product in
                                            NavigationLink(destination: DetailsPageView(product: product)) {
                                                ProductsCard(product: product)
                                                    .padding(.vertical, 5)
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
        }

    }
}

//#Preview {
//    HomeScreenView_()
//}

import SwiftUI
struct ProductsCard: View {
    
    let product: HomeProduct
    
    var body: some View {
        VStack(spacing: 8) {
            
            if let firstImage = product.productImage.first {
                
                let fullURL = "https://ucraft.adwaith.space/uploads/product-images/\(firstImage)"
                    
                
                AsyncImage(
                    url: URL(string: fullURL)
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 110, height: 110)
                .background(Color(.systemGray6))
                .clipped()
                .cornerRadius(10)
                .onAppear {
                    print("IMAGE URL:", fullURL)
                }
            }
            
            Text(product.productName)
                .font(.caption)
                .bold()
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32)
            
            Text("Rs. \(product.salePrice)")
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .frame(width: 154,height: 220)
        .clipped()
        .padding(8)
        .padding(.top,3)
        .background(RoundedRectangle(cornerRadius: 13)
            .fill(Color.white)
                  .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
        )
//        .fill(Color.white)
//        .shadow(radius: 2)
//        .cornerRadius(13)
//        .shadow(radius: 2)
      
    }
}

