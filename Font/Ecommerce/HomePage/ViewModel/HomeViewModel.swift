//
//  HomeViewModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 19/02/26.
//


import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    @Published var items: [Item] = [
        Item(imageName: "HomeImage1", name: "Nike Air Logo Oversized Tee", price: "Rs. 1499"),
        Item(imageName: "HomeImage2", name: "Adidas Black Hoodie", price: "Rs. 1999"),
        Item(imageName: "HomeImage3", name: "Puma Casual Shirt", price: "Rs. 1299"),
        Item(imageName: "HomeImage4", name: "Oversized White Tee", price: "Rs. 999")
    ]
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
