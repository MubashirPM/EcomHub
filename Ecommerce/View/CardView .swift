//
//  CardView .swift
//  Ecommerce
//
//  Created by Mubashir PM on 13/02/26.
//

//import SwiftUI
//
//struct CardView_: View {
//    @State private var showCheckout = false
//    @State private var cartItems = [
//        CartItem(
//            imageName: "HomeImage1",
//            name: "Nike Air Logo OverSize Tee ",
//            price: "$499",
//            quantity: 1
//        ),
//        CartItem(
//            imageName: "HomeImage2",
//            name: "Minimal Classic Tee",
//            price: "$199",
//            quantity: 1
//        ),
//        CartItem(
//            imageName: "HomeImage3",
//            name: "Essential Black Tee",
//            price: "$300",
//            quantity: 1
//        ),
//        CartItem(
//            imageName: "HomeImage4",
//            name: "Oversized Street Tee",
//            price: "$299",
//            quantity: 1
//        )
//    ]
//    
//    var totalPrice : Int {
//        cartItems.reduce(0) {
//            total,
//            item in
//            let priceValue = Int(
//                item.price.replacingOccurrences(of: "$", with: "")
//            ) ?? 0
//            return total + (priceValue * item.quantity)
//        }
//    }
//    
//    var body: some View {
//        ZStack {
//            
//            // MAIN CART CONTENT
//            VStack(spacing: 0) {
//                
//                Text("My Cart")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .padding(.top, 20)
//                    .padding(.bottom, 20)
//                
//                Divider()
//                
//                ScrollView {
//                    VStack(spacing: 0) {
//                        ForEach(cartItems.indices, id: \.self) { index in
//                            CartItemRow(
//                                item: $cartItems[index],
//                                onDelete: {
//                                    cartItems.remove(at: index)
//                                }
//                            )
//                            
//                            Divider()
//                                .padding(.horizontal, 20)
//                        }
//                    }
//                    .padding(.bottom, 120)
//                }
//                
//                Spacer()
//                
//                VStack {
//                    Button(action: {
//                        withAnimation(.spring()) {
//                            showCheckout = true
//                        }
//                    }) {
//                        HStack {
//                            Text("Go to Checkout")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            
//                            Spacer()
//                            
//                            Text("$\(totalPrice)")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                        .background(Color(red: 0.7, green: 0.2, blue: 0.2))
//                        .cornerRadius(15)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 20)
//                }
//                .background(Color.white)
//            }
//            
//            // OVERLAY (Checkout)
//            if showCheckout {
//                
//                // Dim background
//                Color.black.opacity(0.4)
//                    .ignoresSafeArea()
//                    .transition(.opacity)
//                    .onTapGesture {
//                        withAnimation(.spring()) {
//                            showCheckout = false
//                        }
//                    }
//                
//                // Bottom Sheet
//                VStack {
//                    Spacer()
//                    
//                    CheckoutSheet(
//                        totalPrice: totalPrice,
//                        isPresented: $showCheckout
//                    )
//                    .transition(.move(edge: .bottom))
//                }
//            }
//        }
//        .background(Color.white)
//    }
//    
//   
//    
//    struct CartItem : Identifiable {
//        let id = UUID()
//        let imageName : String
//        let name : String
//        let price : String
//        var quantity : Int
//    }
//    
//    struct CartItemRow: View {
//        @Binding var item: CartItem
//        let onDelete: () -> Void
//        
//        var body: some View {
//            HStack(spacing: 15) {
//                // Product Image
//                Image(item.imageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 100, height: 120)
//                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
//                    .cornerRadius(15)
//                    .clipped()
//                
//                // Product Details
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(item.name)
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                        .lineLimit(2)
//                    
//                    Spacer()
//                    
//                    // Quantity Controls
//                    HStack(spacing: 15) {
//                        Button(action: {
//                            if item.quantity > 1 {
//                                item.quantity -= 1
//                            }
//                        }) {
//                            Image(systemName: "minus")
//                                .foregroundColor(.gray)
//                                .frame(width: 35, height: 35)
//                                .background(Color.white)
//                                .overlay(
//                                    Circle()
//                                        .stroke(
//                                            Color.gray.opacity(0.3),
//                                            lineWidth: 1
//                                        )
//                                )
//                        }
//                        
//                        Text("\(item.quantity)")
//                            .font(.headline)
//                            .frame(width: 30)
//                        
//                        Button(action: {
//                            item.quantity += 1
//                        }) {
//                            Image(systemName: "plus")
//                                .foregroundColor(.red)
//                                .frame(width: 35, height: 35)
//                                .background(Color.white)
//                                .overlay(
//                                    Circle()
//                                        .stroke(
//                                            Color.gray.opacity(0.3),
//                                            lineWidth: 1
//                                        )
//                                )
//                        }
//                    }
//                }
//                
//                Spacer()
//                
//                // Price and Delete
//                VStack(spacing: 20) {
//                    // Delete Button
//                    Button(action: onDelete) {
//                        Image(systemName: "xmark")
//                            .foregroundColor(.gray)
//                            .font(.system(size: 18))
//                    }
//                    
//                    Spacer()
//                    
//                    // Price
//                    Text(item.price)
//                        .font(.title3)
//                        .fontWeight(.bold)
//                }
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 15)
//        }
//    }
//}
//
//
//#Preview {
//    CardView_()
//}
