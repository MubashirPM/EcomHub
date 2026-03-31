//
//  CartViewModel.swift
//  Ecommerce
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    
    @Published var showCheckout = false
    @Published var cartItems: [CartItem] = []
    
    // MARK: - Total Price
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.productId.salePrice * Double($1.quantity)) }
    }
    
    
    // MARK: - Increase Quantity
    func increaseQuantity(for item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity += 1
        }
    }
    
    
    // MARK: - Decrease Quantity
    func decreaseQuantity(for item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            }
        }
    }
    
    // MARK: - Remove Item

    func removeItem(userId: String, _ item: CartItem) async {
        guard !userId.isEmpty else { return }
        let success = await removeFromCartAPI(userId: userId, productId: item.productId.id)
        if success {
            cartItems.removeAll { $0.id == item.id }
        }
    }

    private func removeFromCartAPI(userId: String, productId: String) async -> Bool {
        guard let url = URL(string: AppConfig.baseURL + EndPoints.removeFromCart) else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "userId": userId,
            "productId": productId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return false }
            return true
        } catch {
            print("Remove from cart error:", error)
            return false
        }
    }
    
    // MARK: - Add To Cart API
    func addToCart(userId: String, productId: String, quantity: Int) async {
        
        guard let url = URL(string: AppConfig.baseURL + EndPoints.addToCart) else { return }
        
        let body: [String: Any] = [
            "userId": userId,
            "productId": productId,
            "quantity": quantity
        ]
        
        do {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print(String(data: data, encoding: .utf8)!)
            
            let response = try JSONDecoder().decode(AddToCartResponse.self, from: data)
            
            print(response.message)
            
            // Refresh cart after adding
            await fetchCart(userId: userId)
            
        } catch {
            print("Add to cart error:", error)
        }
    }
    
    /// After Razorpay + `/payment/verify` succeeds for a **cart** checkout: empty the UI and
    /// remove each line from the server so the cart stays empty when the user returns.
    @MainActor
    func clearCartAfterSuccessfulPayment(userId: String) async {
        guard !userId.isEmpty else {
            cartItems = []
            return
        }
        let snapshot = cartItems
        cartItems = []
        for item in snapshot {
            _ = await removeFromCartAPI(userId: userId, productId: item.productId.id)
        }
        await fetchCart(userId: userId)
    }

    // MARK: - Fetch Cart API
    func fetchCart(userId: String) async {
        
        guard let url = URL(string: AppConfig.baseURL + EndPoints.getCart(userId: userId))  else { return }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let result = try JSONDecoder().decode(CartResponse.self, from: data)
            
            await MainActor.run {
                self.cartItems = result.items
            }
            
        } catch {
            print("Fetch cart error:", error)
        }
    }
}
