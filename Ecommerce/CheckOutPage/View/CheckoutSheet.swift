//
//  CheckoutSheet.swift
//  Ecommerce
//
//  Created by Mubashir PM on 14/02/26.
//

import SwiftUI

struct CheckoutSheet: View {
    let totalPrice : Int
    @Binding var isPresented : Bool
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Checkout")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                        .bold()
                }
            }
            .padding(.horizontal,20)
            .padding(.top,20)
            .padding(.bottom,20)
            
            HStack {
                Text("Payment")
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Image(systemName: "creditcard.fill")
                    .foregroundStyle(.red)
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal,20)
            .padding(.vertical,15)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(10)
            .padding(.horizontal,20)
            .padding(.bottom,15)
            
            HStack {
                Text("Address")
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Pick a Address")
                    .foregroundStyle(.black)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal,20)
            .padding(.vertical,15)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(10)
            .padding(.horizontal,20)
            .padding(.bottom,15)
            
            HStack {
                Text("Total Cost")
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Rs.\(totalPrice)")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            HStack(spacing: 4) {
                Text("By placing an order you agree to our")
                    .font(.caption)
                    .foregroundColor(.gray)
                           
                Text("Terms")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                           
                Text("And")
                    .font(.caption)
                    .foregroundColor(.gray)
                           
                Text("Conditions")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            NavigationLink(destination: OrderAcceptView()) {
                Text("Place Order")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.custom)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

        }
        .background(Color.white)
             .cornerRadius(30)  // Just use simple cornerRadius
             .shadow(color: .black.opacity(0.2), radius: 20)
    }
}


#Preview {
    CheckoutSheet(totalPrice: 1297, isPresented: .constant(true))
}
