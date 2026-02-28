//
//  OrdersView.swift
//  Ecommerce
//
//  Created by Mubashir PM on 18/02/26.
//

import SwiftUI

struct OrdersView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading,spacing: 24) {
                    OrderCard(
                        status: "Delivered",
                        orderId: "#123456",
                        details: "Chicken x 2, Beverages x 3, Vegetables x 1",
                        price: "$25.00",
                        buttonText: nil
                    )
                                   
                    OrderCard(
                        status: "Ongoing",
                        orderId: "#789012",
                        details: "Chicken x 1, Beverages x 2",
                        price: "$15.00",
//                        buttonText: "Track order"
                    )
                                   
                    OrderCard(
                        status: "Cancelled",
                        orderId: "#345678",
                        details: "Chicken x 3, Beverages x 1",
                        price: "$30.00",
                        buttonText: nil
                    )
                                   
                    OrderCard(
                        status: "Delivered",
                        orderId: "#901234",
                        details: "Chicken x 2, Beverages x 3, Vegetables x 1",
                        price: "$25.00",
//                        buttonText: "Quick reorder"
                    )
                }
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .navigationBar)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(Color(.systemGray6))
                        .navigationTitle("Orders")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.black)
                            }
                        }
        }
    }
}

#Preview {
    OrdersView()
}
struct OrderCard : View {
    
    var status : String
    var orderId : String
    var details : String
    var price : String
    var buttonText : String?
    
    var body: some View {
        VStack(alignment: .leading,spacing: 6) {
            Text(status)
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            Text("Order \(orderId)")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("\(details) . \(price)")
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            if let buttonText = buttonText {
                Button {
                    ""
                } label: {
                    Text(buttonText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal,16)
                        .padding(.vertical,8)
                        .background(Color(.systemGray4))
                        .cornerRadius(20)
                }
                .padding(.top,8)

            }
        }
    }
}
