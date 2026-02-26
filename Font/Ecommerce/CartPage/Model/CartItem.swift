//
//  CartItem.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation

struct CartItem : Identifiable {
    let id = UUID()
    let imageName : String
    let name : String
    let price : Int
    var quantity : Int
}
