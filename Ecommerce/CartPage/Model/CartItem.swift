////
////  CartItem.swift
////  Ecommerce
////
////  Created by Mubashir PM on 25/02/26.
////
//
//import Foundation
//
//struct CartItem: Codable, Identifiable {
//    let id: String
//    let productId: String
//    let productName: String
//    let price: Double
//    var quantity: Int
//    let image: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case productId
//        case productName
//        case price
//        case quantity
//        case image
//    }
//}
//
//struct AddToCartResponse: Codable {
//    let success: Bool
//    let message: String
//}
//
//struct AddToCartRequest: Codable {
//    let userId: String
//    let productId: String
//    let quantity: Int
//}

//
//  CartModels.swift
//  Ecommerce
//

import Foundation

// MARK: - Product Model (Core Product)

struct Product: Codable, Identifiable {
    
    let id: String
    let productName: String
    let description: String?
    let regularPrice: Double?
    let salePrice: Double
    let productImage: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productName
        case description
        case regularPrice
        case salePrice
        case productImage
    }
}


// MARK: - Cart API Response

struct CartResponse: Codable {
    
    let success: Bool
    let items: [CartItem]
    let cartCount: Int
    let hasStockIssue: Bool?
}


// MARK: - Cart Item

struct CartItem: Codable, Identifiable {
    
    let id: String
    let productId: Product
    var quantity: Int
    let isAvailable: Bool?
    let maxStock: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productId
        case quantity
        case isAvailable
        case maxStock
    }
}


// MARK: - Add To Cart Response

struct AddToCartResponse: Codable {
    
    let success: Bool
    let message: String
}


// MARK: - Add To Cart Request

struct AddToCartRequest: Codable {
    
    let userId: String
    let productId: String
    let quantity: Int
}
