//
//  Product.swift
//  Ecommerce
//
//  Created by Mubashir PM on 19/02/26.
//


import Foundation

struct Item: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let price: String
}
struct HomeProduct: Codable, Identifiable {
    let id: String
    let productName: String
    let description: String
    let category: String?
    let subCategory: String?
    let regularPrice: Double
    let salePrice: Double
    let productOffer: Bool
    let quantity: Int
    let productImage: [String]
    let isBlocked: Bool
    let offerPercentage: Int
    let offerEndDate: String?
    let popularityScore: Int
    let averageRating: Double
    let isFeatured: Bool
    let status: String
    let reviews: [String]
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productName
        case description
        case category
        case subCategory
        case regularPrice
        case salePrice
        case productOffer
        case quantity
        case productImage
        case isBlocked
        case offerPercentage
        case offerEndDate
        case popularityScore
        case averageRating
        case isFeatured
        case status
        case reviews
        case createdAt
        case updatedAt
    }
}
struct HomeData: Codable {
    let trending: [HomeProduct]
    let newArrivals: [HomeProduct]
    let featuredCollection: [HomeProduct]
}

struct HomeResponse: Codable {
    let success: Bool
    let data: HomeData
}
