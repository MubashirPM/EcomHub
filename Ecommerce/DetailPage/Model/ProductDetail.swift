//
//  ProductDetail.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//



import Foundation

struct ProductDetail: Identifiable {
    var id = UUID()
    let title: String
    let descriptionLines: [String]
    let name: String
    let price: Int
    let imageName: String
    let description: [String]

    init(
        id: UUID = UUID(),
        title: String,
        descriptionLines: [String],
        name: String,
        price: Int,
        imageName: String,
        description: [String]
    ) {
        self.id = id
        self.title = title
        self.descriptionLines = descriptionLines
        self.name = name
        self.price = price
        self.imageName = imageName
        self.description = description
    }

    /// Creates a ProductDetail from a home screen Item (e.g. for navigation from HomeScreenView).
    init(item: Item) {
        self.id = UUID()
        self.title = item.name
        self.name = item.name
        self.imageName = item.imageName
        let numericString = item.price
            .replacingOccurrences(of: "Rs. ", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)
        self.price = Int(numericString) ?? 0
        self.descriptionLines = []
        self.description = []
    }

    /// Creates a ProductDetail from a HomeProduct (API model) for navigation from home sections.
    init(homeProduct: HomeProduct) {
        self.id = UUID()
        self.title = homeProduct.productName
        self.name = homeProduct.productName
        self.descriptionLines = [homeProduct.description]
        self.description = [homeProduct.description]
        self.price = Int(homeProduct.salePrice)
        let firstImage = homeProduct.productImage.first ?? ""
        self.imageName = firstImage.isEmpty
            ? ""
            : "https://ucraft.adwaith.space/uploads/product-images/\(firstImage)"
    }
}
