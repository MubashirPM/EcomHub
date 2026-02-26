//
//  UserModel.swift
//  Ecommerce
//
//  Created by Mubashir PM on 25/02/26.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let token: String
}
