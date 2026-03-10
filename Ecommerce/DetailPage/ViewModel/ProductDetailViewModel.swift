//
//  ProductDetailViewModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//


import SwiftUI
import Combine

@MainActor
class ProductDetailViewModel: ObservableObject {

    @Published var product: ProductDetail?
    @Published var quantity: Int = 1
    @Published var selectedSize: String = "M"
    @Published var showProductDetail: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    let sizes = ["S", "M", "L", "XL"]

    init() {}

    // MARK: - API CALL
    func fetchProduct(id: String) async {

        debugPrint("fetchProduct called")
        
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "\(AppConfig.baseURL)\(EndPoints.productDetails(id: id))") else {
            errorMessage = "Invalid URL"
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            debugPrint(String(data: data, encoding: .utf8) ?? "No Data")

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Failed to load product"
                isLoading = false
                return
            }

            let decoded: ProductDetailResponse =
            try JSONDecoder().decode(ProductDetailResponse.self, from: data)
            
            debugPrint("Decoded Product :",decoded.product)

            product = ProductDetail(apiProduct: decoded.product)
            debugPrint("Final Product:",product)
            isLoading = false

        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    // MARK: - Quantity
    func increaseQuantity() {
        quantity += 1
    }

    func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }

    // MARK: - Size
    func selectSize(_ size: String) {
        selectedSize = size
    }

    // MARK: - Toggle Description
    func toggleDetailSection() {
        showProductDetail.toggle()
    }
}
