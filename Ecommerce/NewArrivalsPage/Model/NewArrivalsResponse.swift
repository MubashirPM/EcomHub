//
//  NewArrivalsResponse.swift
//  Ecommerce
//
//  Created for New Arrivals API.
//

import Foundation

struct NewArrivalsResponse: Decodable {
    let success: Bool
    let data: [HomeProduct]
}
