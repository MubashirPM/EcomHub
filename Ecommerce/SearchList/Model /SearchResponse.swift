////
////  SearchResponse.swift
////  Ecommerce
////
////  Created by Mubashir PM on 03/03/26.
////
//
//import Foundation
//
//struct SearchResponse: Decodable {
//    let success: Bool
//    let data: [SearchProduct]
//}
//struct SearchProduct: Identifiable, Decodable {
//    
//    let id: Int
//    let productName: String
//    let description: String
//    let category: String
//    let subCategory: String?
//    let regularPrice: Int
//    let salePrice: Int
//    let productOffer: Bool
//    let quantity: Int
//    let productImage: [String]
//    let isBlocked: Bool
//    let offerPercentage: Int
//    let offerEndDate: String?
//    let popularityScore: Int
//    let averageRating: Double
//    let isFeatured: Bool
//    let status: String
//    let reviews: [String]
//    let createdAt: String
//    let updatedAt: String
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case productName
//        case description
//        case category
//        case subCategory
//        case regularPrice
//        case salePrice
//        case productOffer
//        case quantity
//        case productImage
//        case isBlocked
//        case offerPercentage
//        case offerEndDate
//        case popularityScore
//        case averageRating
//        case isFeatured
//        case status
//        case reviews
//        case createdAt
//        case updatedAt
//    }
//}
