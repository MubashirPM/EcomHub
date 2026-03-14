//
//  ProductDetail.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//



import Foundation

struct ProductDetail: Identifiable {
    var id = String()
    let title: String
    let descriptionLines: [String]
    let name: String
    let price: Int
    let imageURL: [String]
    let description: [String]
    let reviews: [Review]?

    init(
        id: String,
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
        self.reviews = []
        
    }

    /// Creates a ProductDetail from a home screen Item (e.g. for navigation from HomeScreenView).
//    init(item: Item) {
//        self.id = UUID()
//        self.title = item.name
//        self.name = item.name
//        self.imageURL = [item.imageName]
//        let numericString = item.price
//            .replacingOccurrences(of: "Rs. ", with: "")
//            .replacingOccurrences(of: ",", with: "")
//            .trimmingCharacters(in: .whitespaces)
//        self.price = Int(numericString) ?? 0
//        self.descriptionLines = []
//        self.description = []
//        self.reviews = []
//    }

    /// Creates a ProductDetail from a HomeProduct (API model) for navigation from home sections.
    init(homeProduct: HomeProduct) {
        self.id = homeProduct.id
        self.title = homeProduct.productName
        self.name = homeProduct.productName
        self.descriptionLines = [homeProduct.description]
        self.description = [homeProduct.description]
        self.price = Int(homeProduct.salePrice)
        self.imageURL = homeProduct.productImage.map {
            "https://ucraft.adwaith.space/uploads/product-images/\($0)"
        }
        self.reviews = []
    }
    
    init(apiProduct: ProductAPI, reviews: [Review]?) {

        self.id = apiProduct.id

        self.title = apiProduct.productName
        self.name = apiProduct.productName

        self.descriptionLines = [apiProduct.description]
        self.description = [apiProduct.description]

        self.price = apiProduct.salePrice

        let firstImage = apiProduct.productImage.first ?? ""

        self.imageURL = apiProduct.productImage.isEmpty ?
            ["https://yourplaceholderurl.com/placeholder.png"] :
        apiProduct.productImage.map { "\(AppConfig.imageBaseURL)\($0)"
        }
        
        self.reviews = reviews ?? []
    }
}


struct ProductDetailResponse: Codable {
    let success: Bool
    let product: ProductAPI
    let reviews: [Review]?
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
    let reviews: [String]?   // IDs only

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productName
        case description
        case regularPrice
        case salePrice
        case quantity
        case status
        case productImage
        case reviews
    }
}

struct AddReviewRequest: Codable {
    let email: String
    let productId: String
    let rating: Int
    let comment: String
}

struct Review: Codable, Identifiable {
    let id: String
    let userName: String
    let userId: String
    let productId: String
    let rating: Int
    let comment: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userName
        case userId
        case productId
        case rating
        case comment
    }
}
