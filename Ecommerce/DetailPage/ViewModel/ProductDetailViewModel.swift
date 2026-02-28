//
//  ProductDetailViewModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//


import SwiftUI
import Combine

class ProductDetailViewModel: ObservableObject {
    
    @Published var product: ProductDetail
    
    @Published var quantity: Int = 1
    @Published var selectedSize: String = "M"
    @Published var showProductDetail: Bool = false
    
    let sizes = ["S", "M", "L", "XL"]
    
    init(product: ProductDetail) {
        self.product = product
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
