//
//  WishlistViewModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 13/03/26.
//


import Foundation
import Combine
import SwiftUI

@MainActor
class WishlistViewModel: ObservableObject {

    @Published var wishlistProductIds: [String] = []
    @Published var wishlistProducts: [HomeProduct] = []
    @Published var isLoading = false

    // MARK: - Get Wishlist

    func fetchWishlist(userId: String) async {
        if userId.isEmpty {
            wishlistProductIds = []
            wishlistProducts = []
            return
        }
        guard let url = URL(string: AppConfig.baseURL + EndPoints.getWishlist(userId: userId)) else { return }

        isLoading = true

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(WishlistResponse.self, from: data)
            let existingById = Dictionary(uniqueKeysWithValues: wishlistProducts.map { ($0.id, $0) })
            let mergedProducts = decoded.wishlist.map { product in
                if product.productImage.isEmpty, let existing = existingById[product.id], !existing.productImage.isEmpty {
                    return existing
                }
                return product
            }
            self.wishlistProducts = mergedProducts
            self.wishlistProductIds = mergedProducts.map { $0.id }
        } catch {
            print("Wishlist fetch error:", error)
            wishlistProductIds = []
            wishlistProducts = []
        }

        isLoading = false
    }

    // MARK: - Add to Wishlist

    private func addToWishlistAPI(userId: String, productId: String) async -> Bool {
        guard let url = URL(string: AppConfig.baseURL + EndPoints.addToWishlist) else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = (try? JSONSerialization.data(withJSONObject: ["userId": userId, "productId": productId]))

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return false }
            return true
        } catch {
            print("Wishlist add error:", error)
            return false
        }
    }

    // MARK: - Remove from Wishlist

    private func removeFromWishlistAPI(userId: String, productId: String) async -> Bool {
        guard let url = URL(string: AppConfig.baseURL + EndPoints.removeFromWishlist) else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = (try? JSONSerialization.data(withJSONObject: ["userId": userId, "productId": productId]))

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return false }
            return true
        } catch {
            print("Wishlist remove error:", error)
            return false
        }
    }

    // MARK: - Toggle (add or remove one product)

    func addToWishlist(userId: String, productId: String, productSnapshot: HomeProduct? = nil) async {
        guard !userId.isEmpty else { return }

        let isCurrentlyFavorite = wishlistProductIds.contains(productId)
        let success: Bool
        if isCurrentlyFavorite {
            success = await removeFromWishlistAPI(userId: userId, productId: productId)
            if success {
                wishlistProductIds.removeAll { $0 == productId }
                wishlistProducts.removeAll { $0.id == productId }
            }
        } else {
            success = await addToWishlistAPI(userId: userId, productId: productId)
            if success {
                wishlistProductIds.append(productId)
                if let productSnapshot, !wishlistProducts.contains(where: { $0.id == productSnapshot.id }) {
                    wishlistProducts.append(productSnapshot)
                }
            }
        }
        if success {
            await fetchWishlist(userId: userId)
        }
    }
    
    
    // MARK: - Check Favorite
    
    func isFavorite(productId: String) -> Bool {
        wishlistProductIds.contains(productId)
    }
}
