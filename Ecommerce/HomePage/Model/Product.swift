//
//  Product.swift
//  Ecommerce
//
//  Created by Mubashir PM on 19/02/26.
//


import Foundation

import Foundation

struct Item: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let price: String
}
