//
//  NewArrivalsview .swift
//  Ecommerce
//
//  Created by Mubashir PM on 12/02/26.
//

import SwiftUI

struct NewArrivalsview_: View {

    @StateObject private var viewModel = NewArrivalsViewModel()
    @Environment(\.dismiss) var dismiss
    @AppStorage("userId") var userId: String = ""
    let wishlistVM: WishlistViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                VStack(spacing: 0) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundStyle(.white)
                                .bold()
                        }

                        FastionStore_()
                        Spacer()
                        NavigationLink {
                            ProfileView()
                                .font(.title3)
                        } label: {
                            ProfileAvatarView()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search Product", text: $viewModel.searchText)
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
                .background(Color.custom)
                .clipShape(RoundedRectangle(cornerRadius: 30))

                Group {
                    if viewModel.isLoading && viewModel.products.isEmpty {
                        ProgressView()
                            .padding(.top, 40)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    } else if viewModel.filteredProducts.isEmpty {
                        Text("No new arrivals found")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]) {
                            ForEach(viewModel.filteredProducts) { product in
                                ZStack(alignment: .topTrailing) {
                                    NavigationLink(destination: DetailsPageView(product: product, wishlistVM: wishlistVM)) {
                                        ProductsCardContent(product: product)
                                    }
                                    WishlistHeartButton(productId: product.id, userId: userId, productSnapshot: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .background(Color.white)
            }
            .navigationBarBackButtonHidden(true)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            viewModel.fetchNewArrivals()
        }
    }
}

#Preview {
    let wishlistVM = WishlistViewModel()
    return NewArrivalsview_(wishlistVM: wishlistVM)
        .environmentObject(wishlistVM)
}
