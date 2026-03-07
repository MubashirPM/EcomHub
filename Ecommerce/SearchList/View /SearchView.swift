////
////  SearchView.swift
////  Ecommerce
////
////  Created by Mubashir PM on 03/03/26.
////
//
//import SwiftUI
//
//
//struct SearchView_: View {
//    
//    @StateObject private var viewModel = SearchViewModel()
//    
//    var body: some View {
//        VStack {
//            
//            // Search Bar
//            HStack {
//                Image(systemName: "magnifyingglass")
//                
//                TextField("Search Store", text: $viewModel.searchText)
//                    .onChange(of: viewModel.searchText) { _ in
//                        viewModel.onSearchTextChanged()
//                    }
//                
//                if !viewModel.searchText.isEmpty {
//                    Button {
//                        viewModel.searchText = ""
//                        viewModel.products.removeAll()
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                    }
//                }
//            }
//            .padding()
//            
//            // Loading
//            if viewModel.isLoading && viewModel.products.isEmpty {
//                ProgressView()
//                    .padding()
//            }
//            
//            // Error
//            if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//            
//            // Empty Results
//            if !viewModel.isLoading &&
//                viewModel.products.isEmpty &&
//                !viewModel.searchText.isEmpty {
//                
//                VStack(spacing: 10) {
//                    Image(systemName: "magnifyingglass")
//                        .font(.largeTitle)
//                        .foregroundColor(.gray)
//                    
//                    Text("No results found")
//                        .foregroundColor(.gray)
//                }
//                .padding(.top, 40)
//            }
//            
////             Results
//            ScrollView {
//                LazyVStack(spacing: 15) {
//                    ForEach(viewModel.products, id: \.id) { product in
//                        VStack(alignment: .leading) {
//                            
//                            if let firstImage = product.productImage.first {
//                                AsyncImage(
//                                    url: URL(string: AppConfig.imageBaseURL + firstImage)
//                                ) { image in
//                                    image
//                                        .resizable()
//                                        .scaledToFill()
//                                } placeholder: {
//                                    ProgressView()
//                                }
//                                .frame(height: 180)
//                                .clipped()
//                            }
//                            
//                            Text(product.productName)
//                                .font(.headline)
//                            
//                            Text("₹ \(product.salePrice)")
//                                .foregroundColor(.gray)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(radius: 2)
//                        .onAppear {
//                            Task {
//                                await viewModel.loadMoreIfNeeded(currentItem: product) // Correctly pass product directly
//                            }
//                        }
//                    }
//                    
//                    if viewModel.isLoading && !viewModel.products.isEmpty {
//                        ProgressView()
//                            .padding()
//                    }
//                }
//                .padding()
//            }
//        }
//    }
//}
