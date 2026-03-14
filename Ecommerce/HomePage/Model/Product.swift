//
//  Product.swift
//  Ecommerce
//
//  Created by Mubashir PM on 19/02/26.
//


import Foundation

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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        productName = try container.decode(String.self, forKey: .productName)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        subCategory = try container.decodeIfPresent(String.self, forKey: .subCategory)
        regularPrice = try container.decode(Double.self, forKey: .regularPrice)
        salePrice = try container.decode(Double.self, forKey: .salePrice)
        productOffer = try container.decode(Bool.self, forKey: .productOffer)
        quantity = try container.decode(Int.self, forKey: .quantity)
        productImage = Self.decodeProductImage(from: decoder)
        isBlocked = try container.decode(Bool.self, forKey: .isBlocked)
        offerPercentage = try container.decode(Int.self, forKey: .offerPercentage)
        offerEndDate = try container.decodeIfPresent(String.self, forKey: .offerEndDate)
        popularityScore = try container.decode(Int.self, forKey: .popularityScore)
        averageRating = try container.decode(Double.self, forKey: .averageRating)
        isFeatured = try container.decode(Bool.self, forKey: .isFeatured)
        status = try container.decode(String.self, forKey: .status)
        reviews = try container.decode([String].self, forKey: .reviews)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }

    /// Decodes image array from "productImage", "product_image", or "image" (single string).
    private static func decodeProductImage(from decoder: Decoder) -> [String] {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        if let arr = try? container?.decode([String].self, forKey: .productImage), !arr.isEmpty {
            return arr
        }
        let altKeys = try? decoder.container(keyedBy: ProductImageKeys.self)
        if let arr = try? altKeys?.decode([String].self, forKey: .productImage), !arr.isEmpty {
            return arr
        }
        if let single = try? altKeys?.decode(String.self, forKey: .image), !single.isEmpty {
            return [single]
        }
        return []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(productName, forKey: .productName)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(subCategory, forKey: .subCategory)
        try container.encode(regularPrice, forKey: .regularPrice)
        try container.encode(salePrice, forKey: .salePrice)
        try container.encode(productOffer, forKey: .productOffer)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(productImage, forKey: .productImage)
        try container.encode(isBlocked, forKey: .isBlocked)
        try container.encode(offerPercentage, forKey: .offerPercentage)
        try container.encodeIfPresent(offerEndDate, forKey: .offerEndDate)
        try container.encode(popularityScore, forKey: .popularityScore)
        try container.encode(averageRating, forKey: .averageRating)
        try container.encode(isFeatured, forKey: .isFeatured)
        try container.encode(status, forKey: .status)
        try container.encode(reviews, forKey: .reviews)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }

    private enum ProductImageKeys: String, CodingKey {
        case productImage = "product_image"
        case image
    }

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
