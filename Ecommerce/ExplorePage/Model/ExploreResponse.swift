//
//  ExploreResponse.swift
//  Ecommerce
//
//  Created by Mubashir PM on 10/03/26.
//


import Foundation

struct ExploreResponse: Decodable {
    let success: Bool
    let count: Int
    let data: [HomeProduct]
}

struct ExploreProduct: Identifiable, Decodable {

    let id: String
    let productName: String
    let description: String
    let regularPrice: Double
    let salePrice: Double
    let quantity: Int
    let productImage: [String]
    let status: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productName
        case description
        case regularPrice
        case salePrice
        case quantity
        case productImage
        case status
    }
}
