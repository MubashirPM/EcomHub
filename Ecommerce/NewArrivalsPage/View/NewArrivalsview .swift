//
//  NewArrivalsview .swift
//  Ecommerce
//
//  Created by Mubashir PM on 12/02/26.
//

import SwiftUI

struct NewArrivalsview_: View {

    @StateObject private var viewModel = NewArrivalsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                VStack(spacing: 0) {
                    HStack {
                        FastionStore_()
                        Spacer()
                        NavigationLink {
                            ProfileView()
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.yellow)
                                .frame(width: 50, height: 50)
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
                                NavigationLink(destination: DetailsPageView(product: product)) {
                                    ProductsCard(product: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .background(Color.white)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            viewModel.fetchNewArrivals()
        }
    }
}

#Preview {
    NewArrivalsview_()
}
