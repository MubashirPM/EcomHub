//
//  ExploreView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 13/02/26.
//

//import SwiftUI
//
//struct ExploreView: View {
//    
//    @StateObject var viewModel = ExploreViewModel()
//    @State private var searchText = ""
//    @Binding var selectedTab: Int
//    
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    var filteredProducts: [HomeProduct] {
//        if searchText.isEmpty {
//            return viewModel.products
//        } else {
//            return viewModel.products.filter {
//                $0.productName.lowercased().contains(searchText.lowercased())
//            }
//        }
//    }
//    
//    var body: some View {
//        
//        ZStack(alignment: .top){
//            Color(.custom)
//                .ignoresSafeArea()
//            
//            VStack(spacing: 5) {
//                
//                VStack(spacing: 0) {
//                    
//                    HStack {
//                        FastionStore_()
//                            .font(.title3)
//                        
//                        Spacer()
//                        
//                        Button {
//                            selectedTab = 4
//                        } label: {
//                            Image(systemName: "person.crop.circle.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.yellow)
//                                .frame(width: 50, height: 50)
//                        }
//                    }
//                    .padding(.horizontal, 20)
//                    // Search Bar
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                        
//                        TextField("Search products", text: $searchText)
//                        
//                        if !searchText.isEmpty {
//                            Button {
//                                searchText = ""
//                            } label: {
//                                Image(systemName: "xmark.circle.fill")
//                            }
//                        }
//                    }
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                    
//                    ScrollView {
//                        
//                        LazyVGrid(columns: columns, spacing: 20) {
//                            
//                            ForEach(filteredProducts) { product in
//                                
//                                NavigationLink(
//                                    destination: DetailsPageView(
//                                        product: product
//                                    )
//                                ) {
//                                    
//                                    ProductsCard(product: product)
//                                    
//                                }
//                                .buttonStyle(.plain)
//                                .onAppear {
//                                    viewModel
//                                        .loadMoreProducts(currentItem: product)
//                                }
//                            }
//                            
//                            if viewModel.isLoading {
//                                ProgressView()
//                                    .padding()
//                            }
//                        }
//                        .padding()
//                        .padding(.bottom,80)
//                    }
//                }
//            }
////            .navigationTitle("Explore")
//            .onAppear {
//                viewModel.fetchExploreProducts()
//            }
//        }
//    }
//}

import SwiftUI

struct ExploreView: View {

    @StateObject var viewModel = ExploreViewModel()
    @State private var searchText = ""
    @Binding var selectedTab: Int
    @AppStorage("userId") var userId: String = ""
    @EnvironmentObject private var wishlistVM: WishlistViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var filteredProducts: [HomeProduct] {
        if searchText.isEmpty {
            return viewModel.products
        } else {
            return viewModel.products.filter {
                $0.productName.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {

        ZStack(alignment: .top) {

            Color(.custom)
                .ignoresSafeArea()

            VStack(spacing: 5) {

                

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

                        TextField("Search Item", text: $searchText)

                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }

                

                ZStack {

                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .ignoresSafeArea(edges: .bottom)

                    ScrollView {

                        LazyVGrid(columns: columns, spacing: 20) {

                            ForEach(filteredProducts) { product in
                                ZStack(alignment: .topTrailing) {
                                    NavigationLink(destination: DetailsPageView(product: product, wishlistVM: wishlistVM)) {
                                        ProductsCardContent(product: product)
                                    }
                                    .buttonStyle(.plain)
                                    WishlistHeartButton(productId: product.id, userId: userId)
                                }
                                .onAppear {
                                    viewModel.loadMoreProducts(currentItem: product)
                                }
                            }

                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchExploreProducts()
        }
    }
}
