//
//  ExploreView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 13/02/26.
//



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
                            ProfileAvatarView()
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
                                    WishlistHeartButton(productId: product.id, userId: userId, productSnapshot: product)
                                }
                                .onAppear {
                                    if searchText.isEmpty {
                                        Task {
                                            await viewModel.loadMoreIfNeeded(currentItem: product)
                                        }
                                    }
                                }
                            }

                            if viewModel.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
            }
        }
        .task {
            await viewModel.loadIfEmpty()
        }
    }
}
