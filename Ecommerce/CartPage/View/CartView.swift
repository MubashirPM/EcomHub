//
//  CartView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//
//

import SwiftUI

struct CartView: View {

    @AppStorage("userId") private var userId: String = ""
    @StateObject private var viewModel = CartViewModel()
    @State private var showOrderAccepted = false
    
    private var roundedTotalPrice: Int {
        Int(viewModel.totalPrice.rounded())
    }

    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                
                Text("My Cart")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                Divider()
                
                ScrollView {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(viewModel.cartItems) { item in
                            
                            CartItemRow(
                                item: item,
                                increase: {
                                    viewModel.increaseQuantity(for: item)
                                },
                                decrease: {
                                    viewModel.decreaseQuantity(for: item)
                                },
                                delete: {
                                    Task {
                                        await viewModel.removeItem(userId: userId, item)
                                    }
                                }
                            )
                            
                            Divider()
                                .padding(.horizontal,20)
                        }
                    }
                    .padding(.bottom,120)
                }
                
                Spacer()
                
                Button {
                    viewModel.showCheckout = true
                } label: {
                    
                    HStack {
                        
                        Text("Go to Checkout")
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Rs.\(viewModel.totalPrice, specifier: "%.2f")")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.custom)
                    .cornerRadius(15)
                }
                .padding()
            }
            
        }
        .sheet(isPresented: $viewModel.showCheckout) {
            CheckoutSheet(
                totalPrice: roundedTotalPrice,
                isPresented: $viewModel.showCheckout,
                onPaymentVerified: {
                    Task { @MainActor in
                        await viewModel.clearCartAfterSuccessfulPayment(userId: userId)
                    }
                    showOrderAccepted = true
                }
            )
            .presentationDetents([.height(430)])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(30)
        }
        .fullScreenCover(isPresented: $showOrderAccepted) {
            OrderAcceptView {
                showOrderAccepted = false
                Task {
                    if !userId.isEmpty {
                        await viewModel.fetchCart(userId: userId)
                    }
                }
            }
        }
        .task {
            if !userId.isEmpty {
                await viewModel.fetchCart(userId: userId)
            }
        }
    }
}


struct CartItemRow: View {
    
    let item: CartItem
    let increase: () -> Void
    let decrease: () -> Void
    let delete: () -> Void
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            AsyncImage(
                url: URL(
                    string: "https://ucraft.adwaith.space/uploads/product-images/\(item.productId.productImage.first ?? "")"
                )
            ) { image in
                
                image
                    .resizable()
                    .scaledToFill()
                
            } placeholder: {
                
                ProgressView()
            }
            .frame(width: 100, height: 120)
            .cornerRadius(15)
            
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(item.productId.productName)
                    .font(.headline)
                    .lineLimit(2)
                
                Spacer()
                
                HStack(spacing: 15) {
                    
                    Button(action: decrease) {
                        Image(systemName: "minus")
                    }
                    
                    Text("\(item.quantity)")
                    
                    Button(action: increase) {
                        Image(systemName: "plus")
                            .foregroundColor(.red)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                
                Button(action: delete) {
                    Image(systemName: "xmark")
                }
                
                Spacer()
                
                Text("Rs.\(item.productId.salePrice, specifier: "%.2f")")
                    .font(.headline)
            }
        }
        .padding()
    }
}
