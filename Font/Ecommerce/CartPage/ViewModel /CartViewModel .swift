//
//  CartViewModel .swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation
import Combine


class CartViewModel: ObservableObject {
    
    @Published var showCheckout = false
    @Published var cartItems : [CartItem] = [
        CartItem(imageName: "HomeImage1",
                 name: "Nike Air Logo OverSize Tee",
                 price: 499,
                 quantity: 1),
                
        CartItem(imageName: "HomeImage2",
                 name: "Minimal Classic Tee",
                 price: 199,
                 quantity: 1),
                
        CartItem(imageName: "HomeImage3",
                 name: "Essential Black Tee",
                 price: 300,
                 quantity: 1),
                
        CartItem(imageName: "HomeImage4",
                 name: "Oversized Street Tee",
                 price: 299,
                 quantity: 1)
    ]
    var totalPrice : Int {
        cartItems.reduce(0) {$0 + ($1.price * $1.quantity)}
    }
    func increaseQuantity(for item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity += 1
        }
    }
    func decreaseQuantity(for item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            }
        }
    }
    func removeItem(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
    }
}
