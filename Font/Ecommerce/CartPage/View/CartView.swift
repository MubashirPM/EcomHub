//
//  CartView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
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
                                    viewModel.removeItem(item)
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
                        
                        Text("$\(viewModel.totalPrice)")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(15)
                }
                .padding()
            }
            if viewModel.showCheckout {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.showCheckout = false
                    }
                VStack {
                    Spacer()
                    
                    CheckoutSheet(
                        totalPrice: viewModel.totalPrice,
                        isPresented: $viewModel.showCheckout
                    )
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
                
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
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
                    
                    Text("$\(item.price)")
                        .font(.headline)
                }
            }
            .padding()
        }
    }
}
