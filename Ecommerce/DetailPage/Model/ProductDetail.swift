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
    let imageURL: [String]
    let description: [String]

    init(
        id: UUID = UUID(),
        title: String,
        descriptionLines: [String],
        name: String,
        price: Int,
        imageName: [String],
        description: [String]
    ) {
        self.id = id
        self.title = title
        self.descriptionLines = descriptionLines
        self.name = name
        self.price = price
        self.imageURL = imageName
        self.description = description
    }

    /// Creates a ProductDetail from a home screen Item (e.g. for navigation from HomeScreenView).
    init(item: Item) {
        self.id = UUID()
        self.title = item.name
        self.name = item.name
        self.imageURL = [item.imageName]
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
        self.imageURL = homeProduct.productImage.map {
            "https://ucraft.adwaith.space/uploads/product-images/\($0)"
        }
    }
    
    init(apiProduct: ProductAPI) {

        self.id = UUID()

        self.title = apiProduct.productName
        self.name = apiProduct.productName

        self.descriptionLines = [apiProduct.description]
        self.description = [apiProduct.description]

        self.price = apiProduct.salePrice

        let firstImage = apiProduct.productImage.first ?? ""

        self.imageURL = apiProduct.productImage.map {
            "\(AppConfig.imageBaseURL)\($0)"
        }
    }
}



struct ProductDetailResponse: Codable {
    let success: Bool
    let product: ProductAPI
}

struct ProductAPI: Codable {
    let id: String
    let productName: String
    let description: String
    let regularPrice: Int
    let salePrice: Int
    let quantity: Int
    let status: String
    let productImage: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productName
        case description
        case regularPrice
        case salePrice
        case quantity
        case status
        case productImage
    }
}
