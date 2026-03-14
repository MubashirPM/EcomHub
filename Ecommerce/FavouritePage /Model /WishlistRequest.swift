//
//  WishlistRequest.swift
//  Ecommerce
//
//  Created by Mubashir PM on 13/03/26.
//


struct AddWishlistResponse: Codable {
    let success: Bool
    let message: String
    let wishlist: WishlistData
}

struct WishlistData: Codable {
    let _id: String
    let userId: String
    let products: [String]
}
struct WishlistResponse: Codable {
    let success: Bool
    let wishlist: [HomeProduct]
}
